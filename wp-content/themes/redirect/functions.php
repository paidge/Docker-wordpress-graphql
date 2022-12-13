<?php
// Exit if accessed directly
if (!defined('ABSPATH')) { exit; }

// Disable gutenberg
add_filter("use_block_editor_for_post_type", false);

// Customize backend CSS
add_action('admin_print_styles', function() {
	$admin_handle = 'admin_css';
	$admin_stylesheet = get_template_directory_uri() . '/admin.css';

	wp_enqueue_style($admin_handle, $admin_stylesheet);
}, 11);

// Activate blog thumbnails
add_action( 'after_setup_theme', function() {
  add_theme_support( 'post-thumbnails' );
});


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
});

// Activate menu locations
add_action( 'init', function() {
  register_nav_menu('main-menu',__( 'Main menu' ));
});
