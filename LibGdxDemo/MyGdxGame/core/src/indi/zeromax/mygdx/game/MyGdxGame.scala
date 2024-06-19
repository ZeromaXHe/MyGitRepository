package indi.zeromax.mygdx.game

import com.badlogic.gdx.graphics.g2d.SpriteBatch
import com.badlogic.gdx.graphics.{OrthographicCamera, Texture}
import com.badlogic.gdx.math.{MathUtils, Rectangle, Vector3}
import com.badlogic.gdx.utils.{Array, ScreenUtils, TimeUtils}
import com.badlogic.gdx.{Gdx, Input, Screen}

import scala.jdk.CollectionConverters.*

/**
 * @author Zhu Xiaohe
 * @note
 * @since 2024-06-17 17:51
 */
class MyGdxGame extends Screen {
  private var game: Drop = _

  private var bucketImage: Texture = _
  private var dropImage: Texture = _
  private var batch: SpriteBatch = _
  private var camera: OrthographicCamera = _
  private var bucket: Rectangle = _
  private var raindrops: Array[Rectangle] = _
  private var lastDropTime: Long = _

  def this(game: Drop) = {
    this()
    this.game = game

    // 为雨滴和桶加载图片，使用默认项目图片（256x256 像素）
    bucketImage = Texture("badlogic.jpg")
    dropImage = Texture("badlogic.jpg")
    // 创建相机和 SpriteBatch
    camera = OrthographicCamera()
    camera.setToOrtho(false, 800f, 480f)
    batch = SpriteBatch()
    // 创建代表桶的 Rectangle
    bucket = Rectangle()
    // 使桶水平居中
    bucket.x = 800 / 2 - 64 / 2
    // 桶的左下角离屏幕下边缘 20 像素
    bucket.y = 20
    bucket.width = 64
    bucket.height = 64
    // 创建雨滴数组并生成第一滴雨水
    raindrops = Array[Rectangle]()
    spawnRaindrop()
  }

  private def spawnRaindrop(): Unit = {
    val raindrop = Rectangle()
    raindrop.x = MathUtils.random(0, 800 - 64)
    raindrop.y = 480
    raindrop.width = 64
    raindrop.height = 64
    raindrops.add(raindrop)
    lastDropTime = TimeUtils.nanoTime()
  }

  override def render(delta: Float): Unit = {
    // 使用暗蓝色清除屏幕
    // clear() 的入参代表红，绿，蓝和 alpha，范围 [0,1]，表示用来清理的颜色
    ScreenUtils.clear(0, 0, 0.2f, 1)
    // 告诉相机更新它的矩阵
    camera.update()
    // 告诉 SpriteBatch 以相机指定的坐标系进行渲染。
    batch.setProjectionMatrix(camera.combined);
    // 开始一个新批次，并画出桶和所有雨滴，大小缩小为 64x64
    batch.begin()
    batch.draw(bucketImage, bucket.x, bucket.y, 64, 64)
    for (raindrop <- raindrops.asScala) {
      batch.draw(dropImage, raindrop.x, raindrop.y, 64, 64)
    }
    batch.end()
    // 处理用户输入
    if (Gdx.input.isTouched) {
      val touchPos = Vector3()
      touchPos.set(Gdx.input.getX.toFloat, Gdx.input.getY.toFloat, 0)
      camera.unproject(touchPos)
      bucket.x = touchPos.x - 64 / 2
    }
    if (Gdx.input.isKeyPressed(Input.Keys.LEFT)) {
      bucket.x -= 200 * delta
    }
    if (Gdx.input.isKeyPressed(Input.Keys.RIGHT)) {
      bucket.x += 200 * delta
    }
    // 确保桶留在屏幕边界内
    bucket.x = MathUtils.clamp(bucket.x, 0f, 800f - 64f)
    // check if we need to create a new raindrop
    if (TimeUtils.nanoTime - lastDropTime > 1000000000) {
      spawnRaindrop()
    }
    // 移动雨滴，删除任何低于屏幕下边缘或碰到桶的雨滴
    val iter = raindrops.iterator()
    while (iter.hasNext) {
      val raindrop = iter.next
      raindrop.y -= 200 * delta
      if (raindrop.y + 64 < 0 || raindrop.overlaps(bucket)) {
        // 暂时不知道这个在 Scala 里面 for 怎么翻译比较好，只好用 while 了
        iter.remove()
      }
    }
  }


  override def dispose(): Unit = {
    // dispose of all the native resources
    dropImage.dispose()
    bucketImage.dispose()
    batch.dispose()
  }

  override def show(): Unit = {}

  override def resize(width: Int, height: Int): Unit = {}

  override def pause(): Unit = {}

  override def resume(): Unit = {}

  override def hide(): Unit = {}
}
