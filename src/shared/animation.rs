use bevy::prelude::*;

pub trait AnimationType {
    fn indices(&self) -> (usize, usize);
    fn is_repeting(&self) -> bool;
    fn from_json() -> fn(Self) -> (usize, usize) {
        todo!()
    }
}

#[derive(Debug, Clone, Copy, Component, Reflect)]
pub struct Animator<T: AnimationType>(pub T);

pub struct AnimationPlugin;
impl Plugin for AnimationPlugin {
    fn build(&self, app: &mut App) {
        app.register_type::<AnimationTimer>();
    }
}

#[derive(Event, Reflect)]
#[allow(dead_code)]
pub struct AnimationEnded<T: AnimationType> {
    entity: u32,
    animation: Animator<T>,
}

#[derive(Component, Deref, DerefMut, Reflect)]
pub struct AnimationTimer(pub Timer);

// TODO: make it take timer
pub fn handle_animation<T: AnimationType + Component + Copy + 'static>(
    time: Res<Time>,
    mut query: Query<(&Animator<T>, &mut AnimationTimer, &mut TextureAtlas, Entity)>,
    mut event_writer: EventWriter<AnimationEnded<T>>,
) {
    for (anim, mut timer, mut texture_atlas, entity) in query.iter_mut() {
        timer.tick(time.delta());
        if timer.just_finished() {
            let (first, last) = anim.0.indices();
            let mut index = texture_atlas.index;
            if !(index >= first && index <= last) {
                index = first;
            }
            match anim.0.is_repeting() {
                true => {
                    if index >= last {
                        index = first
                    } else {
                        index += 1
                    }
                }
                false => {
                    if index >= last {
                        event_writer.send(AnimationEnded {
                            entity: entity.index(),
                            animation: *anim,
                        });
                    } else {
                        index += 1
                    }
                }
            }
            texture_atlas.index = index;
        }
    }
}
