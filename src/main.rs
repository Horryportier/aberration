mod camera;

mod helpers;
mod player;
mod tileset;
mod velocity;

use bevy::prelude::*;
use bevy_ecs_tilemap::TilemapPlugin;
use bevy_inspector_egui::quick::WorldInspectorPlugin;
use velocity::Velocity;

fn main() {
    App::new()
        .insert_resource(ClearColor(Color::hex("0c0b12").unwrap()))
        .add_plugins((
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
            TilemapPlugin,
            WorldInspectorPlugin::default(),
        ))
        .add_plugins((
            //tileset::TileSetPlugin,
            camera::CameraPlugin,
            velocity::VelocityPlugin,
            player::PlayerPlugin,
        ))
        .run()
}
