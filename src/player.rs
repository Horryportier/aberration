use bevy::prelude::*;

use crate::Velocity;

#[derive(Component)]
pub struct Player;

pub struct PlayerPlugin;

impl Plugin for PlayerPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Startup, spawn_player)
            .add_systems(Update, player_movement);
    }
}

pub fn spawn_player(mut commands: Commands, assets_server: Res<AssetServer>) {
    let texture_handle = assets_server.load("sword.png");

    commands.spawn((
        SpriteBundle {
            texture: texture_handle,
            ..Default::default()
        },
        Player,
        Velocity(Vec3::default()),
    ));
}
// FIX: Encountered a panic when applying buffers for system `aberration::player::spawn_player`!
// bevy_ecs::system::commands::command_queue: CommandQueue has un-applied commands being dropped.
// bevy_ecs::system::commands::command_queue: CommandQueue has un-applied commands being dropped.
// Encountered a panic in system `bevy_app::main_schedule::Main::run_main`!
fn player_movement(
    mut player: Query<&mut Velocity, With<Player>>,
    keys: Res<ButtonInput<KeyCode>>,
) {
    let Ok(mut v) = player.get_single_mut() else {
        return;
    };
    let mut key_vel = Velocity(Vec3::default());

    if keys.pressed(KeyCode::KeyD) {
        key_vel.x += 1.0;
    }

    if keys.pressed(KeyCode::KeyA) {
        key_vel.x -= 1.0;
    }

    if keys.pressed(KeyCode::KeyW) {
        key_vel.y += 1.0;
    }

    if keys.pressed(KeyCode::KeyS) {
        key_vel.y -= 1.0;
    }

    v.0 += key_vel.0;
}
