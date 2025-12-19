---
layout: post
title: "站在巨人的肩膀上开发游戏(5) -- 打砖块游戏制作续"
categories:
- "游戏开发"
tags: []
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '20'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

其实在上一节，游戏已经基本成型了，但是还不能算是完整的游戏，本篇将需要完善的部分完成吧。

<!-- more -->

## 游戏加个边框

这个实在不需要我额外讲方法了，按原来的办法加上四周的边框即可。不过这里讲几个个人总结的技巧：

- **需要显示边框**：直接创建一个边框即可。
- **不需要显示边框**：
  1. 将边框创建在显示范围以外；
  2. 使用完全透明的图像；
  3. 使用不透明图像，但放在 Z 轴超出视景体（Box2D 忽略 Z 轴）。

这里为了省事，直接使用 Orx 作者提供的资源，采用第一种方法。

### 墙体配置（wall.ini）

```ini
; Wall

[WallTemplate]
Graphic   = WallGraphic
Body      = WallBody
BlendMode = alpha

[WallGraphic]
Texture = data/wall.png
Pivot   = center

[Walls]
ChildList = Wall1 # Wall2 # Wall3 # Wall4

[Wall1@WallTemplate]
Position = (0.0, 250, 0.0)
Rotation = 90.0

[Wall2@WallTemplate]
Position = (-170, 0.0, 0.0)

[Wall3@WallTemplate]
Position = (0.0, -250, 0.0)
Rotation = 90.0

[Wall4@WallTemplate]
Position = (170, 0.0, 0.0)

[WallBody]
PartList = WallBox
Dynamic  = false

[WallBox]
Type        = box
Friction    = 1.0
Restitution = 0.0
SelfFlags   = 0x0001
CheckMask   = 0x0001
Solid       = true
```

在 `game.ini` 中加入：

```
@wall.ini@
```

初始化时创建墙体对象：

```cpp
if (orxObject_CreateFromConfig("Walls") == NULL) {
    result = orxSTATUS_FAILURE;
}
```

---

## 响应输入

游戏的核心在于交互，这里通过键盘输入控制挡板移动。

### 输入配置

```ini
[Input]
SetList   = Input
KEY_LEFT  = GoLeft
KEY_RIGHT = GoRight
```

### Update 回调

```cpp
void GameApp::Update(const orxCLOCK_INFO *_clock_info, void *_context)
{
#define MOVE_SPEED 10

    if (orxInput_IsActive("GoLeft")) {
        orxVECTOR pos;
        orxObject_GetPosition(gPaddle, &pos);
        pos.fX -= MOVE_SPEED;
        orxObject_SetPosition(gPaddle, &pos);
    }

    if (orxInput_IsActive("GoRight")) {
        orxVECTOR pos;
        orxObject_GetPosition(gPaddle, &pos);
        pos.fX += MOVE_SPEED;
        orxObject_SetPosition(gPaddle, &pos);
    }
}
```

至此，游戏已经可以通过左右方向键进行游玩。

---

## 完整示例代码

（已统一缩进、修复断行、规范化）

```cpp
#include "orx.h"
#include <string>

using namespace std;

orxOBJECT* gPaddle = nullptr;

class GameApp {
public:
    static orxSTATUS orxFASTCALL EventHandler(const orxEVENT *_pstEvent);
    static orxSTATUS orxFASTCALL Init();
    static void      orxFASTCALL Exit();
    static orxSTATUS orxFASTCALL Run();
    static void      orxFASTCALL Update(const orxCLOCK_INFO *_clock_info, void *_context);

    static GameApp* Instance() {
        static GameApp instance;
        return &instance;
    }

private:
    orxSTATUS InitGame();
};

orxSTATUS GameApp::InitGame() {
    orxSTATUS result = orxSTATUS_SUCCESS;

    orxCLOCK *pstClock = orxClock_Create(orx2F(0.05f), orxCLOCK_TYPE_USER);
    orxClock_Register(pstClock, GameApp::Update, nullptr,
                      orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);

    if (!orxViewport_CreateFromConfig("Viewport")) result = orxSTATUS_FAILURE;
    if (!orxObject_CreateFromConfig("Ball"))       result = orxSTATUS_FAILURE;
    if (!(gPaddle = orxObject_CreateFromConfig("Paddle")))
        result = orxSTATUS_FAILURE;
    if (!orxObject_CreateFromConfig("Blocks"))     result = orxSTATUS_FAILURE;
    if (!orxObject_CreateFromConfig("Walls"))      result = orxSTATUS_FAILURE;

    orxEvent_AddHandler(orxEVENT_TYPE_PHYSICS, GameApp::EventHandler);
    return result;
}

orxSTATUS orxFASTCALL GameApp::EventHandler(const orxEVENT *_pstEvent) {
    if (_pstEvent->eType == orxEVENT_TYPE_PHYSICS &&
        _pstEvent->eID   == orxPHYSICS_EVENT_CONTACT_REMOVE) {

        orxOBJECT *sender = orxOBJECT(_pstEvent->hSender);
        string name(orxObject_GetName(sender));

        if (name.rfind("Block", 0) == 0) {
            orxObject_SetLifeTime(sender, orxFLOAT_0);
        }
    }
    return orxSTATUS_SUCCESS;
}

orxSTATUS GameApp::Init() {
    orxLOG("Init() called!");
    return Instance()->InitGame();
}

void GameApp::Exit() {
    orxLOG("Exit() called!");
}

orxSTATUS GameApp::Run() {
    return orxSTATUS_SUCCESS;
}

int main(int argc, char **argv) {
    orx_Execute(argc, argv, GameApp::Init, GameApp::Run, GameApp::Exit);
    return EXIT_SUCCESS;
}
```

---

## 参考资料

- Ray Wenderlich 的 Box2D Breakout 教程  
- https://orx-project.org  
