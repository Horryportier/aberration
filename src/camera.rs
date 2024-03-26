use bevy::prelude::*;
use std::ops::Neg;

use crate::{player::Player, Velocity};

pub struct CameraPlugin;

impl Plugin for CameraPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Startup, spawn_camera)
            .add_systems(Update, camera_control);
    }
}

const DEF_ZOOM: Vec3 = Vec3::splat(0.5);

fn camera_control(
    mut camera: Query<(&mut Velocity, &mut Transform), (With<Camera2d>, Without<Player>)>,
    player: Query<&Transform, With<Player>>,
    keys: Res<ButtonInput<KeyCode>>,
) {
    let Ok((mut cv, mut ct)) = camera.get_single_mut() else {
        println!("no player");
        return;
    };
    // player folow
    {
        let pt = player.single();
        let distance = (ct.translation - pt.translation).neg();
        let lerp = Vec3::default().lerp(distance, 0.99);
        cv.x = lerp.x;
        cv.y = lerp.y;
    }
    // zoom
    {
        let zoom_change = Vec2::new(0.01, 0.01);

        if keys.pressed(KeyCode::Equal) {
            ct.scale.x -= zoom_change.x;
            ct.scale.y -= zoom_change.y;
        }
        if keys.pressed(KeyCode::Minus) {
            ct.scale.x += zoom_change.x;
            ct.scale.y += zoom_change.y;
        }
        ct.scale = ct.scale.clamp(Vec3::splat(0.01), Vec3::splat(4.));
    }
}

fn spawn_camera(mut commands: Commands) {
    let mut camera_bundle = Camera2dBundle::default();
    camera_bundle.transform = camera_bundle.transform.with_scale(DEF_ZOOM);
    commands.spawn((camera_bundle, Velocity(Vec2::default())));
}
