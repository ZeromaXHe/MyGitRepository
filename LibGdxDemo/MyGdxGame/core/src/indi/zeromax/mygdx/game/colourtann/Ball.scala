package indi.zeromax.mygdx.game.colourtann

import com.badlogic.gdx.Gdx
import com.badlogic.gdx.graphics.Color
import com.badlogic.gdx.graphics.glutils.ShapeRenderer

/**
 * @author Zhu Xiaohe
 * @note 参考教程：https://colourtann.github.io/HelloLibgdx/
 * @since 2024/6/24 23:01
 */
class Ball {
  var x: Int = _
  var y: Int = _
  var size: Int = _
  var xSpeed: Int = _
  var ySpeed: Int = _
  var color: Color = Color.WHITE

  def this(x: Int, y: Int, size: Int, xSpeed: Int, ySpeed: Int) = {
    this()
    this.x = x
    this.y = y
    this.size = size
    this.xSpeed = xSpeed
    this.ySpeed = ySpeed
  }

  def update(): Unit = {
    x += xSpeed
    y += ySpeed
    if (x < 0 || x > Gdx.graphics.getWidth) {
      xSpeed = -xSpeed
    }
    if (y < 0 || y > Gdx.graphics.getHeight) {
      ySpeed = -ySpeed
    }
  }

  def draw(shape: ShapeRenderer): Unit = {
    shape.setColor(color)
    shape.circle(x.toFloat, y.toFloat, size.toFloat)
  }

  def checkCollision(paddle: Paddle): Unit = {
    if (collidesWith(paddle)) {
      color = Color.GREEN
    } else {
      color = Color.WHITE
    }
  }

  private def collidesWith(paddle: Paddle): Boolean = {
    val recCenterX = paddle.x + paddle.width / 2
    val recCenterY = paddle.y + paddle.height / 2
    val v0 = Math.abs(x - recCenterX)
    val v1 = Math.abs(y - recCenterY)
    val h0 = paddle.width / 2
    val h1 = paddle.height / 2
    val u0 = Math.max(v0 - h0, 0)
    val u1 = Math.max(v1 - h1, 0)
    u0 * u0 + u1 * u1 <= size * size
  }
}
