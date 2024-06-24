package indi.zeromax.mygdx.game.colourtann

import com.badlogic.gdx.Gdx
import com.badlogic.gdx.graphics.glutils.ShapeRenderer

/**
 * @author zhuxi
 * @note
 * @since 2024/6/24 23:46
 */
class Paddle {
  var x: Int = _
  var y: Int = _
  var width: Int = _
  var height: Int = _
  var xSpeed: Int = _
  var ySpeed: Int = _

  def this(x: Int, y: Int, width: Int, height: Int) = {
    this()
    this.x = x
    this.y = y
    this.width = width
    this.height = height
  }

  def update(): Unit = {
    x = Gdx.input.getX - width / 2
    y = Gdx.graphics.getHeight - (Gdx.input.getY + height / 2)
  }

  def draw(shape: ShapeRenderer): Unit = {
    shape.rect(x.toFloat, y.toFloat, width.toFloat, height.toFloat)
  }
}
