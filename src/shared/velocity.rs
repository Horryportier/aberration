use bevy::prelude::*;

#[derive(Debug, Component, Deref, DerefMut, Reflect)]
pub struct Velocity(pub Vec2);
#[derive(Debug, Component, Deref, DerefMut, Reflect)]
pub struct Speed(pub f32);

pub struct VelocityPlugin;

impl Plugin for VelocityPlugin {
    fn build(&self, app: &mut App) {
        app.register_type::<Velocity>()
            .register_type::<Speed>()
            .add_systems(Update, velocity_system);
    }
}

pub fn velocity_system(mut query: Query<(&mut Velocity, &mut Transform)>) {
    for (mut velocity, mut transform) in query.iter_mut() {
        transform.translation.x += velocity.x;
        transform.translation.y += velocity.y;
        // NOTE: there should be friction commponent taht would decrease velocity.
        velocity.0 = velocity.mul_add(Vec2::splat(0.5), Vec2::ZERO);
    }
}
