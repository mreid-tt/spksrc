<?php
/* Custom Icinga Web 2 entry point for Synology DSM */
/* Sets environment variables that PHP-FPM cannot read from .htaccess */

putenv('ICINGAWEB_CONFIGDIR=/var/packages/icingaweb2/var/etc/icingaweb2');
putenv('ICINGAWEB_LIBDIR=/var/packages/icingaweb2/target/share/icinga-php');

require_once dirname(__DIR__) . '/library/Icinga/Application/webrouter.php';
