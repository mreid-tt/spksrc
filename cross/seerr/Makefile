PKG_NAME = seerr
PKG_VERS = 2.7.3
PKG_EXT = tar.gz
PKG_PATCHES_LEVEL = 0
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/seerr-team/seerr/archive/refs/tags
PKG_DIST_FILE = seerr-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = seerr-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs_22

HOMEPAGE = https://github.com/seerr-team/seerr
COMMENT  = Media request management with Jellyfin, Plex, and Emby integration.
LICENSE  = MIT

ENV += NPM_CONFIG_PREFIX=$(WORK_DIR)/npm-global
ENV += PATH=$(WORK_DIR)/npm-global/bin:$(WORK_DIR)/../../../native/nodejs_22/work-native/node/bin:$(PATH)
ENV += COREPACK_ENABLE_DOWNLOAD=1
ENV += HUSKY=0
ENV += HUSKY_SKIP_INSTALL=1
ENV += SKIP_GIT_INSTALL_HOOKS=1

INSTALL_TARGET = seerr_install

include ../../mk/spksrc.install-resources.mk

.PHONY: seerr_install
seerr_install:
	install -m 755 -d $(WORK_DIR)/npm-global/bin
	$(RUN) npm install -g pnpm@9.0.0
	$(RUN) node -e "const fs=require('fs');const path='package.json';const pkg=JSON.parse(fs.readFileSync(path));if(pkg.scripts&&pkg.scripts.prepare){delete pkg.scripts.prepare;fs.writeFileSync(path,JSON.stringify(pkg,null,2));}"
	$(RUN) node -e "const fs=require('fs');const path='next.config.js';let content=fs.readFileSync(path,'utf8');if(!content.includes(\"output: 'standalone'\")){const marker='module.exports = {\\n';content=content.replace(marker,\"module.exports = {\\n  output: 'standalone',\\n\");fs.writeFileSync(path,content);}" 
	$(RUN) pnpm install --frozen-lockfile --filter '.' --config.ignore-workspace-root-check=true
	$(RUN) COMMIT_TAG=$(PKG_VERS) pnpm build
	$(RUN) pnpm prune --prod --ignore-scripts
	# DSM Fix: Update standalone server to respect HOST env var
	$(RUN) sed -i "s/const hostname = process.env.HOSTNAME || '0.0.0.0'/const hostname = process.env.HOST || process.env.HOSTNAME || '0.0.0.0'/" .next/standalone/server.js
	# Remove pnpm store metadata to reduce PLIST noise
	$(RUN) rm -rf node_modules/.pnpm/.store
	# Drop platform-specific SWC binaries we cannot use at runtime (keep linux glibc)
	$(RUN) rm -rf node_modules/.pnpm/@next+swc-*-darwin@*
	$(RUN) rm -rf node_modules/.pnpm/@next+swc-*-win32@*
	$(RUN) rm -rf node_modules/.pnpm/@next+swc-linux-*-musl@*
	$(RUN) rm -rf node_modules/.pnpm/@swc+core-*-darwin@*
	$(RUN) rm -rf node_modules/.pnpm/@swc+core-*-win32@*
	$(RUN) rm -rf node_modules/.pnpm/@swc+core-linux-*-musl@*
	# Remove optional React Native toolchain pulled in by react-spring animation bundles
	$(RUN) find node_modules/.pnpm -maxdepth 1 -type d -name 'react-native@*' -prune -exec rm -rf {} +
	$(RUN) find node_modules/.pnpm -maxdepth 1 -type d -name '@react-native*' -prune -exec rm -rf {} +
	$(RUN) rm -rf node_modules/.pnpm/jsc-android@*
	$(RUN) rm -rf node_modules/.pnpm/@react-three@*
	# Remove unused sharp variants (keep glibc build only)
	$(RUN) rm -rf node_modules/.pnpm/@img+sharp-libvips-linuxmusl-*@*
	# Strip build-time tooling no longer needed for production runtime
	$(RUN) rm -rf node_modules/.pnpm/typescript@*
	$(RUN) rm -rf node_modules/.pnpm/ts-node@*
	$(RUN) rm -rf src server .next/cache charts gen-docs docs
	# Remove TypeScript metadata and sourcemaps to shrink footprint further
	$(RUN) find node_modules -type f \( -name '*.d.ts' -o -name '*.d.mts' -o -name '*.d.cts' -o -name '*.map' -o -name '*.tsbuildinfo' \) -delete
	$(RUN) touch config/DOCKER
	$(RUN) node -e "require('fs').writeFileSync('committag.json', JSON.stringify({commitTag: '$(PKG_VERS)'}))"
	$(RUN) rm -rf node_modules package.json pnpm-lock.yaml
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/seerr
	cp -a $(WORK_DIR)/$(PKG_DIR)/dist $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/public $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/config $(STAGING_INSTALL_PREFIX)/share/seerr/
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/seerr/.next
	cp -a $(WORK_DIR)/$(PKG_DIR)/.next/standalone $(STAGING_INSTALL_PREFIX)/share/seerr/.next/
	cp -a $(WORK_DIR)/$(PKG_DIR)/.next/static $(STAGING_INSTALL_PREFIX)/share/seerr/.next/
	cp $(WORK_DIR)/$(PKG_DIR)/committag.json $(STAGING_INSTALL_PREFIX)/share/seerr/
	( cd $(STAGING_INSTALL_PREFIX) && find share/seerr -type f -o -type l | sort ) > $(WORK_DIR)/$(PKG_NAME).plist
	printf 'rsc:share/seerr\n' > $(WORK_DIR)/PLIST
