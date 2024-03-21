use bevy::prelude::*;

#[derive(Debug, Component, Deref, DerefMut)]
pub struct Velocity(pub Vec3);
#[derive(Debug, Component, Deref, DerefMut)]
pub struct Speed(pub f32);

pub struct VelocityPlugin;

impl Plugin for VelocityPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Update, velocity_system);
    }
}

pub fn velocity_system(mut query: Query<(&mut Velocity, &mut Transform)>) {
    for (mut velocity, mut transform) in query.iter_mut() {
        transform.translation += **velocity;
        // NOTE: there should be friction commponent taht would decrease velocity.
        velocity.0 = velocity.mul_add(Vec3::splat(0.5), Vec3::ZERO);
    }
}
