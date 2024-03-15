mod camera;

mod player;
mod tileset;
mod velocity;

use bevy::prelude::*;
use bevy_inspector_egui::quick::WorldInspectorPlugin;
use velocity::Velocity;

fn main() {
    App::new()
        .insert_resource(ClearColor(Color::hex("0c0b12").unwrap()))
        .add_plugins(default_plugins())
        .add_plugins((
            camera::CameraPlugin,
            velocity::VelocityPlugin,
            tileset::TileSetPlugin,
            player::PlayerPlugin,
        ))
        .run()
}

/// NOTE: returns default plugins and 3d party plugins.
fn default_plugins() -> (bevy::app::PluginGroupBuilder, WorldInspectorPlugin) {
    (
        DefaultPlugins
            .set(WindowPlugin {
                primary_window: Some(Window {
                    title: "bevy_app".into(),
                    window_level: bevy::window::WindowLevel::AlwaysOnTop,
                    resizable: true,
                    ..Default::default()
                }),
                ..Default::default()
            })
            .set(ImagePlugin::default_nearest()),
        WorldInspectorPlugin::default(),
    )
}
