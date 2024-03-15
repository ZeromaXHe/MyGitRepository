# 第22课 高级SQL特性

## 22.1 约束

完整性（referential integrity）

约束（constraint）

注意：具体DBMS的约束

### 22.1.1 主键

关键字PRIMARY KEY

CONSTRAINT PRIMARY KEY语法，用于CREATE TABLE和ALTER TABLE语句

说明：SQLite中的键	SQLite不允许使用ALTER TABLE定义键

### 22.1.2 外键

REFERENCES关键字

也可以在ALTER TABLE语句中用CONSTRAINT FOREIGN KEY语法来完成

提示：外键有助防止意外删除	级联删除（cascading delete）

### 22.1.3 唯一约束

唯一约束和主键的重要区别

UNIQUE约束

UNIQUE关键字在表定义中定义，也可以用单独的CONSTRAINT定义

### 22.1.4 检查约束

CHECK

提示：用户定义数据类型

## 22.2 索引

CREATE INDEX语句

提示：检查索引

## 22.3 触发器

提示：约束比触发器更快

## 22.4 数据库安全

GRANT和REVOKE语句

## 22.5 小结