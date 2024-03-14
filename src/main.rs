pub mod camera;


mod player;

use bevy::prelude::*;


fn main() {
    App::new()
        .insert_resource(ClearColor(Color::hex("201c5a").unwrap()))
        .add_plugins(
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
        )
        .add_systems(Startup, setup).add_systems(Update, velocity_system)
        .add_plugins((player::PlayerPlugin, camera::CameraPlugin))
        .run()
}

#[derive(Debug, Component, Deref, DerefMut)]
pub struct Velocity(pub Vec3);

fn velocity_system(mut query: Query<(&Velocity, &mut Transform)>) {
    for (velocity, mut transform) in query.iter_mut() {
        println!("{:?}", velocity);
        transform.translation += **velocity;
    }
}

fn setup(mut commands: Commands) {
    commands.spawn((Camera2dBundle::default(), Velocity(Vec3::default())));
}


