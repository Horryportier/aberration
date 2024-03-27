use clap::ValueEnum;

#[derive(Default)]
pub struct GameOptions {
    pub ui: UiType,
}

#[derive(ValueEnum, Debug, PartialEq, Clone, Copy, Default)]
#[clap(rename_all = "kebab_case")]
pub enum UiType {
    Game,
    Dev,
    #[default]
    DevSimple,
}
