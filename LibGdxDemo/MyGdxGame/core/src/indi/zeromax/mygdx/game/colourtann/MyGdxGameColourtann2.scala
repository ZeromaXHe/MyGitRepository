package indi.zeromax.mygdx.game.colourtann

import com.badlogic.gdx.graphics.GL20
import com.badlogic.gdx.{ApplicationAdapter, Gdx}
import com.badlogic.gdx.graphics.glutils.ShapeRenderer

/**
 * @author zhuxi
 * @note
 * @since 2024/6/24 23:50
 */
class MyGdxGameColourtann2 extends ApplicationAdapter {
  var shape: ShapeRenderer = _
  var ball: Ball = _
  var paddle: Paddle = _

  override def create(): Unit = {
    shape = ShapeRenderer()
    ball = Ball(Gdx.graphics.getWidth / 2, Gdx.graphics.getHeight / 2,
      10, 0, 0)
    paddle = Paddle(Gdx.graphics.getWidth / 2, Gdx.graphics.getHeight / 2, 100, 10)
  }

  override def render(): Unit = {
    Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)

    shape.begin(ShapeRenderer.ShapeType.Filled)
    ball.checkCollision(paddle)
    ball.update()
    ball.draw(shape)
    paddle.update()
    paddle.draw(shape)
    shape.end()
  }
}
