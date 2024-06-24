package indi.zeromax.mygdx.game.libgdx.simple

import com.badlogic.gdx.Game
import com.badlogic.gdx.graphics.g2d.{BitmapFont, SpriteBatch}

/**
 * @author Zhu Xiaohe
 * @note 教程：https://libgdx.com/wiki/start/simple-game-extended
 * @since 2024/6/19 16:02
 */
class Drop extends Game {
  var batch: SpriteBatch = null
  var font: BitmapFont = null

  def create(): Unit = {
    batch = SpriteBatch()
    font = BitmapFont() // use libGDX's default Arial font

    this.setScreen(MainMenuScreen(this))
  }

  override def render(): Unit = {
    super.render() // important!
  }

  override def dispose(): Unit = {
    batch.dispose()
    font.dispose()
  }
}
