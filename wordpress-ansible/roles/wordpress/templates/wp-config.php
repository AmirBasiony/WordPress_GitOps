<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', '{{ wp_db_env.DB_NAME }}' ?: 'wordpress_db' );

/** Database username */
define( 'DB_USER', '{{ wp_db_env.DB_USER }}' ?: 'wp_user' );

/** Database password */
define( 'DB_PASSWORD', '{{ wp_db_env.DB_PASSWORD }}' ?: 'admin@obelion' );

/** Database hostname */
// define( 'DB_HOST', '127.0.0.1:3306' );
define( 'DB_HOST', '{{ wp_db_env.DB_HOST }}' ?: '127.0.0.1:3306' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '75jEbvWsOu8FAhtMBLfv0vgWct7lAWVMOB0mi/knye6TCI4bIKZ5qbfM7ojR5JO0' );
define( 'SECURE_AUTH_KEY',  'Tjv3N5BJ4GRUeGmYOHrd9j7Q0LtGuawakfftWX2cT1IOvgAs9Kdbxavxf/h2KpI1' );
define( 'LOGGED_IN_KEY',    'Vec2dGCcWWAWFD/+UL1FTKZY0R19mWQZFPdYdpwcm16bS1L6cGrsnA+W1gqu16ai' );
define( 'NONCE_KEY',        '6Wpp2jAJJBxpXWJpFrZGXHmEIUZfkhqjyA3A8es/SLzXFnZaDjuY1ABkXZQO107W' );
define( 'AUTH_SALT',        'oS2eHH5utjShW2NrbDbAXDrSLsTXC/bnagRCgdD6cUqnj2sFuEBIf2GBP0HzXKdz' );
define( 'SECURE_AUTH_SALT', 'gNBGzRbKQViFoEkFf0d5ZM7rMbVtceeLwLunbUe3e/pC/arZ4OKi171kD85x7paH' );
define( 'LOGGED_IN_SALT', 'UrB3/xsySsTZwL+VVoEni8jtBHU9hpLQPJlPhFOXjbGsyesJUCo03jTxrqVC1KQt' );
define( 'NONCE_SALT',       'd/Vbx5YH1FbGc6L4ao56B0xI1y7iMl5oPIT9JJVk4kjKeHoiS7irLPCpdj9VUs/G' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */

if (!empty($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
	$_SERVER['HTTPS'] = 'on';
  }
  

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
