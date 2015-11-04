<?php if ( ! defined( 'KISS' ) ) exit;

// Path to system folder, with trailing slash
$conf['system_path'] = 'APP_DIR/system/';

// Path to app folder, with trailing slash
$conf['application_path'] = 'APP_DIR/app/';

// Path to view directory, with trailing slash
$conf['view_path'] = $conf['application_path'].'views/';

// Path to controller directory, with trailing slash
$conf['controller_path'] = $conf['application_path'].'controllers/';

// Path to modules directory, with trailing slash
$conf['module_path'] = $conf['application_path'] . "modules/";
