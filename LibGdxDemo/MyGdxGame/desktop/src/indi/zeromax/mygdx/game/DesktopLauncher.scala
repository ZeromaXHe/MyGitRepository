package indi.zeromax.mygdx.game

import com.badlogic.gdx.backends.lwjgl3.{Lwjgl3Application, Lwjgl3ApplicationConfiguration}

/**
 * @author Zhu Xiaohe
 * @note
 * @since 2024/6/17 18:11
 */
object DesktopLauncher {
  def main(arg: Array[String]): Unit = {
    val config = new Lwjgl3ApplicationConfiguration() {
      setForegroundFPS(60)
      setTitle("MyGdxGame")
      setWindowedMode(256, 256)
    }
    new Lwjgl3Application(Drop(), config)
  }
}
