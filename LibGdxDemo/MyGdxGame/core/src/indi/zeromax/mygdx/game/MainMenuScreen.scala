package indi.zeromax.mygdx.game

import com.badlogic.gdx.Gdx
import com.badlogic.gdx.Screen
import com.badlogic.gdx.graphics.OrthographicCamera
import com.badlogic.gdx.utils.ScreenUtils

/**
 * @author Zhu Xiaohe
 * @note
 * @since 2024/6/19 15:57
 */
class MainMenuScreen extends Screen {
  var game: Drop = _

  var camera: OrthographicCamera = _

  def this(game: Drop) = {
    this()
    this.game = game
    camera = new OrthographicCamera {
      setToOrtho(false, 800, 480)
    }
  }

  override def show(): Unit = {}

  override def render(delta: Float): Unit = {
    ScreenUtils.clear(0, 0, 0.2f, 1)

    camera.update()
    game.batch.setProjectionMatrix(camera.combined)

    game.batch.begin()
    game.font.draw(game.batch, "Welcome to Drop!!! ", 100, 150)
    game.font.draw(game.batch, "Tap anywhere to begin!", 100, 100)
    game.batch.end()

    if (Gdx.input.isTouched) {
      game.setScreen(MyGdxGame(game))
      dispose()
    }
  }

  override def resize(width: Int, height: Int): Unit = {}

  override def pause(): Unit = {}

  override def resume(): Unit = {}

  override def hide(): Unit = {}

  override def dispose(): Unit = {}
}
