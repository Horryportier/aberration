use bevy::prelude::*;
// FIX: figure out how to do it with genrecis or not use them

pub trait AnimationType {
    fn indices(self) -> (usize, usize);
    fn is_repeting(self) -> bool;
    fn from_json() -> fn(Self) -> (usize, usize) {
        todo!()
    }
}

#[derive(Debug, Clone, Copy, Component)]
pub struct Animator<T: AnimationType>(T);

pub struct AnimationPlugin;
impl Plugin for AnimationPlugin {
    fn build(&self, app: &mut App) {}
}

fn next_anim_frame<T: AnimationType + Sync + Send + 'static>(
    query: Query<(&Animator<T>, &mut TextureAtlas)>,
) {
}
