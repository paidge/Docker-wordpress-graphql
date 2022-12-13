<?php
// Exit if accessed directly
if (!defined('ABSPATH')) {
    exit;
}

// Disable gutenberg
add_filter("use_block_editor_for_post_type", "disable_gutenberg_editor");
function disable_gutenberg_editor()
{
return false;
}

// Customize backend CSS
function admin_css() {
	$admin_handle = 'admin_css';
	$admin_stylesheet = get_template_directory_uri() . '/admin.css';

	wp_enqueue_style($admin_handle, $admin_stylesheet);
}
add_action('admin_print_styles', 'admin_css', 11);

// Activate blog thumbnails
function mytheme_post_thumbnails() {
    add_theme_support( 'post-thumbnails' );
}
add_action( 'after_setup_theme', 'mytheme_post_thumbnails' );


// Add custom fields in wpgraphql
add_action( 'graphql_register_types', function() {
  register_graphql_field( 'Page', 'my_custom_field', [
     'type' => 'String',
     'description' => 'Description',
     'resolve' => function( $post ) {
       $my_custom_field = get_post_meta( $post->ID, 'my_custom_field', true );
       return ! empty( $my_custom_field ) ? $my_custom_field : '';
     }
  ] );
} );

// Activate menu locations
function register_my_menu() {
register_nav_menu('main-menu',__( 'Main menu' ));
}
add_action( 'init', 'register_my_menu' );
