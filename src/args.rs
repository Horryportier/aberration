use anyhow::Ok;
use clap::Parser;

use crate::opts::{GameOptions, UiType};

#[derive(Parser, Debug, PartialEq)]
pub struct Args {
    #[arg(long)]
    ui: UiType,
}

impl Args {
    pub fn exec(&self) -> anyhow::Result<GameOptions> {
        let opts = GameOptions { ui: self.ui };
        return Ok(opts);
    }
}
