package indi.zeromax.mygdx.game.colourtann

import com.badlogic.gdx.graphics.GL20
import com.badlogic.gdx.{ApplicationAdapter, Gdx}
import com.badlogic.gdx.graphics.glutils.ShapeRenderer

import scala.util.Random

/**
 * @author zhuxi
 * @note 教程：https://colourtann.github.io/HelloLibgdx/
 * @since 2024/6/24 23:07
 */
class MyGdxGameColourtann1 extends ApplicationAdapter {
  var shape: ShapeRenderer = _
  var balls: List[Ball] = _
  val r: Random = Random()

  override def create(): Unit = {
    shape = ShapeRenderer()
    balls = (for (i <- 0 until 10)
      yield Ball(r.nextInt(Gdx.graphics.getWidth), r.nextInt(Gdx.graphics.getHeight),
        r.nextInt(100), r.nextInt(15), r.nextInt(15))
      ).toList
  }

  override def render(): Unit = {
    Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)

    shape.begin(ShapeRenderer.ShapeType.Filled)
    for (ball <- balls) {
      ball.update()
      ball.draw(shape)
    }
    shape.end()
  }
}
