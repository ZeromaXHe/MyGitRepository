package indi.zeromax;

import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Scanner;
import java.util.stream.Stream;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/2/17 11:43
 */
public class RandomFileChooser {
    /**
     * 扫描的目录
     */
    public static String DIR;

    enum RequiredType {
        BOOK,
        IMG,
        VIDEO,
    }

    /**
     * 要扫描的后缀扩展名
     */
    public static final HashSet<String> IMG_POSTFIXES = new HashSet<>();
    public static final HashSet<String> VIDEO_POSTFIXES = new HashSet<>();
    public static final HashSet<String> BOOK_POSTFIXES = new HashSet<>();

    public static final List<Path> CHOOSE_LIST = new ArrayList<>();

    static {
        String img_extensions = ".png,.jpg,.jpeg,.bmp,.gif,.bmp,.webp";
        String video_extensions = ".avi,.mkv,.mp4,.wmv,.mpg,.mpeg,.mov,.flv,.swf";
        String book_extensions = ".doc,.docx,.txt,.pdf";
        IMG_POSTFIXES.addAll(Arrays.asList(img_extensions.split(",")));
        VIDEO_POSTFIXES.addAll(Arrays.asList(video_extensions.split(",")));
        BOOK_POSTFIXES.addAll(Arrays.asList(book_extensions.split(",")));
    }

    public static void main(String[] args) {
        System.out.println("请输入路径：");
        Scanner scanner = new Scanner(System.in);
        DIR = scanner.nextLine();
        while (!new File(DIR).isDirectory()) {
            System.out.println("路径错误，请重新输入路径：");
            DIR = scanner.nextLine();
        }
        System.out.println("请输入随机类型：1 书籍、2 图片文件夹、3 视频");
        int type = scanner.nextInt();
        while (type > 3 || type < 1) {
            System.out.println("类型错误，请重新输入类型：");
            type = scanner.nextInt();
        }

        RequiredType requiredType = switch (type) {
            case 1 -> RequiredType.BOOK;
            case 2 -> RequiredType.IMG;
            case 3 -> RequiredType.VIDEO;
            default -> throw new IllegalStateException("Unexpected value: " + type);
        };
        findRequiredFileAndFillList(Paths.get(DIR), requiredType);
        if (CHOOSE_LIST.isEmpty()) {
            System.out.println("啥也没找到，结束！");
            return;
        }
        Random random = new Random();
        randomChoose(scanner, random);
    }

    private static void randomChoose(Scanner scanner, Random random) {
        int idx = random.nextInt(CHOOSE_LIST.size());
        Path path = CHOOSE_LIST.get(idx);
        System.out.println(path);
        System.out.println("请输入接下来的操作：1 再随机一个、2 桌面软件打开、3 结束");
        int op = scanner.nextInt();
        while (op > 3 || op < 1) {
            System.out.println("操作错误，请重新输入操作编号：");
            op = scanner.nextInt();
        }
        switch (op) {
            case 1 -> randomChoose(scanner, random);
            case 2 -> openFileInDesktop(path.toString());
        }
    }

    private static void findRequiredFileAndFillList(Path path, RequiredType requiredType) {
        System.out.println("开始扫描路径：" + path.toString());
        try (Stream<Path> pathStream = Files.walk(path)) {
            CHOOSE_LIST.addAll(pathStream.filter(p -> isRequiredFile(p, requiredType))
                    .toList());
            System.out.println("扫描完成，所有符合类型的个数为：" + CHOOSE_LIST.size());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static boolean isRequiredFile(Path path, RequiredType requiredType) {
        switch (requiredType) {
            case IMG -> {
                if (!isValidDir(path)) {
                    return false;
                }
                try (Stream<Path> stream = Files.list(path)) {
                    return stream.filter(p -> {
                        String str = p.toString();
                        return IMG_POSTFIXES.stream().anyMatch(str::endsWith);
                    }).count() >= 10;
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
            case BOOK -> {
                if (!path.toFile().isFile()) {
                    return false;
                }
                String str = path.toString();
                return BOOK_POSTFIXES.stream().anyMatch(str::endsWith);
            }
            case VIDEO -> {
                if (!path.toFile().isFile()) {
                    return false;
                }
                String str = path.toString();
                return VIDEO_POSTFIXES.stream().anyMatch(str::endsWith);
            }
            default -> {
                return false;
            }
        }
    }

    private static boolean isValidDir(Path path) {
        File file = path.toFile();
        return /*file.exists() && */file.isDirectory();
    }

    private static void openFileInDesktop(String path) {
        Desktop desk = Desktop.getDesktop();
        try {
            File file = new File(path);
            desk.open(file);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
