package indi.zeromax.mygdx.game

import com.badlogic.gdx.ApplicationAdapter
import com.badlogic.gdx.graphics.Texture
import com.badlogic.gdx.graphics.g2d.SpriteBatch
import com.badlogic.gdx.utils.ScreenUtils

/**
 * @author Zhu Xiaohe
 * @note
 * @since 2024-06-17 17:51
 */
class MyGdxGame extends ApplicationAdapter {
  private[game] var batch: SpriteBatch = null
  private[game] var img: Texture = null

  override def create(): Unit = {
    batch = new SpriteBatch
    img = new Texture("badlogic.jpg")
  }

  override def render(): Unit = {
    ScreenUtils.clear(1, 0, 0, 1)
    batch.begin()
    batch.draw(img, 0, 0)
    batch.end()
  }

  override def dispose(): Unit = {
    batch.dispose()
    img.dispose()
  }
}
