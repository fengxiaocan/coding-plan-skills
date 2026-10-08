# Dev Android Unified Design 使用指南

## 1. 概述与设计理念

`dev-android-unified-design` 是一套面向现代 Android（Jetpack Compose / View）开发的系统化 UI/UX 设计与落地规范工作流。其设计灵感来源于 **Google Stitch**：强调**简洁、纯粹、高信息层级、克制留白、统一度量衡、高度抗挤压与无障碍支持**。

### 核心设计哲学
- **组件分工明晰**：业务页面只负责“组合与装配”，设计系统（Design System）负责“决定外观与尺寸”。
- **零 Magic Number**：所有间距、字号、字重、圆角、高度必须来自全局 Design Token。
- **抗脆弱布局**：界面在 320dp 极窄屏幕、150% 系统字体放大、超长国际化文案下依然保持稳健不崩溃。

---

## 2. 触发方式与交互示例

### 命令行触发
```bash
/dev-android-unified-design
```

### 带目标描述的触发
```bash
# 需求开发：创建规范化业务页面
/dev-android-unified-design 实现一个网络测速页面，包含当前测速仪表盘卡片、网络信息分组和开始测速主操作按钮

# 代码重构：治理老旧混乱 UI
/dev-android-unified-design 重构 SettingScreen.kt，消除里面的裸写 dp/sp，将零散的 Card 合并为 Section 分组卡片

# 设计系统基建：搭建基础组件库
/dev-android-unified-design 为项目初始化一套符合 Stitch 规范的 Compose Design System 基础 Tokens 和常用公共组件
```

---

## 3. 标准 Design System 架构范例（Kotlin Compose）

推荐项目结构：
```text
ui/
├── theme/
│   ├── Color.kt          # 语义色彩体系
│   ├── Typography.kt     # 文字排印层级
│   ├── Shape.kt          # 圆角等级 (8dp, 12dp, 16dp, 20dp, Full)
│   ├── Dimensions.kt     # 4dp 栅格间距、组件高度、触控尺寸
│   └── Theme.kt          # 统一 Theme、MaterialTheme 映射与 CompositionLocal
└── components/
    ├── AppButton.kt      # 统一按钮（主/次/线框/文本/图标）
    ├── AppIconButton.kt  # 48dp 触控标准图标按钮
    ├── AppCard.kt        # 分组与状态卡片
    ├── AppListItem.kt    # 标准列表项与设置项
    ├── AppTextField.kt   # 统一高度与状态输入框
    ├── AppDialog.kt      # 响应式弹窗（小屏纵向防拉伸）
    ├── AppTopBar.kt      # 56dp 标准顶部导航栏
    ├── AppDivider.kt     # 1dp 语义分割线
    └── AppStateViews.kt  # Loading, Empty, Error 统一状态视图
```

### 3.1 Dimensions.kt（度量体系）
```kotlin
package com.example.ui.theme

import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

object AppDimensions {
    // 4dp Grid 栅格间距
    val spacingMicro: Dp = 2.dp     // 极小微调
    val spacingTiny: Dp = 4.dp      // 紧凑内边距
    val spacingSmall: Dp = 8.dp     // 小元素间距
    val spacingMedium: Dp = 12.dp   // 关联元素间距
    val spacingNormal: Dp = 16.dp   // 标准间距、页面与卡片默认 Padding
    val spacingLarge: Dp = 20.dp    // 中大间距
    val spacingXLarge: Dp = 24.dp   // Section 区块间距、大屏页面边距
    val spacingHuge: Dp = 32.dp     // 大区块留白
    val spacingSection: Dp = 48.dp  // 超大留白

    // 按钮恒定高度
    val buttonHeightLarge: Dp = 52.dp
    val buttonHeightMedium: Dp = 48.dp
    val buttonHeightSmall: Dp = 36.dp

    // 控件标准高度
    val topBarHeight: Dp = 56.dp
    val textFieldHeight: Dp = 56.dp
    val listItemHeightSingle: Dp = 56.dp
    val listItemHeightDouble: Dp = 72.dp
    val dividerThickness: Dp = 1.dp

    // 触控安全区域
    val minTouchTarget: Dp = 48.dp

    // 平板与宽屏最大内容宽度
    val maxContentWidthCompact: Dp = 600.dp
    val maxContentWidthExpanded: Dp = 840.dp
}
```

### 3.2 Shape.kt（圆角分级）
```kotlin
package com.example.ui.theme

import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.unit.dp

object AppShapes {
    val small: Shape = RoundedCornerShape(8.dp)      // Chip, Badge, 小控件
    val medium: Shape = RoundedCornerShape(12.dp)    // 输入框 TextField
    val large: Shape = RoundedCornerShape(16.dp)     // 卡片 Card
    val xLarge: Shape = RoundedCornerShape(20.dp)    // Dialog 弹窗, BottomSheet
    val full: Shape = CircleShape                    // 圆形按钮, 头像, 图标背景
}
```

### 3.3 Typography.kt（文字排印体系）
```kotlin
package com.example.ui.theme

import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

object AppTypography {
    val titleLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.SemiBold,
        fontSize = 22.sp,
        lineHeight = 28.sp
    )
    val titleMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Medium,
        fontSize = 18.sp,
        lineHeight = 24.sp
    )
    val titleSmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Medium,
        fontSize = 16.sp,
        lineHeight = 22.sp
    )
    val bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp
    )
    val bodyMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 14.sp,
        lineHeight = 20.sp
    )
    val bodySmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 12.sp,
        lineHeight = 16.sp
    )
    val labelLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Medium,
        fontSize = 14.sp,
        lineHeight = 20.sp
    )
    val labelMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Medium,
        fontSize = 12.sp,
        lineHeight = 16.sp
    )
    val labelSmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Medium,
        fontSize = 11.sp,
        lineHeight = 14.sp
    )
}
```

---

## 4. 核心公共组件封装（Jetpack Compose）

### 4.1 AppButton.kt（统一按钮与防换行机制）
```kotlin
package com.example.ui.components

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.example.ui.theme.AppDimensions
import com.example.ui.theme.AppShapes
import com.example.ui.theme.AppTypography

enum class AppButtonSize { Large, Medium, Small }

@Composable
fun AppPrimaryButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    loading: Boolean = false,
    size: AppButtonSize = AppButtonSize.Medium,
    leadingIcon: (@Composable () -> Unit)? = null
) {
    val targetHeight = when (size) {
        AppButtonSize.Large -> AppDimensions.buttonHeightLarge
        AppButtonSize.Medium -> AppDimensions.buttonHeightMedium
        AppButtonSize.Small -> AppDimensions.buttonHeightSmall
    }

    Button(
        onClick = onClick,
        modifier = modifier.height(targetHeight),
        enabled = enabled && !loading,
        shape = AppShapes.medium,
        contentPadding = PaddingValues(horizontal = AppDimensions.spacingNormal)
    ) {
        if (loading) {
            CircularProgressIndicator(
                modifier = Modifier.size(18.dp),
                color = MaterialTheme.colorScheme.onPrimary,
                strokeWidth = 2.dp
            )
        } else {
            leadingIcon?.invoke()
            Text(
                text = text,
                style = AppTypography.labelLarge,
                maxLines = 1,              // 绝对禁止换行拉伸
                softWrap = false,          // 绝对禁止软折行
                overflow = TextOverflow.Ellipsis
            )
        }
    }
}
```

### 4.2 AppIconButton.kt（触控靶心保障）
```kotlin
package com.example.ui.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.material.ripple.rememberRipple
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.unit.dp
import com.example.ui.theme.AppDimensions

@Composable
fun AppIconButton(
    icon: ImageVector,
    contentDescription: String?,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true
) {
    // 外层强制至少 48dp 触控区域，内层图标保持 24dp 优雅视觉
    Box(
        modifier = modifier
            .size(AppDimensions.minTouchTarget)
            .clickable(
                interactionSource = remember { MutableInteractionSource() },
                indication = rememberRipple(bounded = false, radius = 24.dp),
                enabled = enabled,
                role = Role.Button,
                onClick = onClick
            ),
        contentAlignment = Alignment.Center
    ) {
        Icon(
            imageVector = icon,
            contentDescription = contentDescription,
            modifier = Modifier.size(24.dp),
            tint = if (enabled) MaterialTheme.colorScheme.onSurface else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f)
        )
    }
}
```

### 4.3 AppCard.kt & 分组 Section
```kotlin
package com.example.ui.components

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import com.example.ui.theme.AppDimensions
import com.example.ui.theme.AppShapes
import com.example.ui.theme.AppTypography

@Composable
fun AppCard(
    modifier: Modifier = Modifier,
    content: @Composable ColumnScope.() -> Unit
) {
    Card(
        modifier = modifier.fillMaxWidth(),
        shape = AppShapes.large,
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp) // 极简扁平，不使用厚重阴影
    ) {
        Column(
            modifier = Modifier.padding(AppDimensions.spacingNormal),
            content = content
        )
    }
}

@Composable
fun AppSection(
    title: String,
    modifier: Modifier = Modifier,
    content: @Composable ColumnScope.() -> Unit
) {
    Column(modifier = modifier.fillMaxWidth()) {
        Text(
            text = title,
            style = AppTypography.labelMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(
                start = AppDimensions.spacingSmall,
                bottom = AppDimensions.spacingSmall
            )
        )
        AppCard(content = content)
        Spacer(modifier = Modifier.height(AppDimensions.spacingXLarge)) // Section 间留白 24dp
    }
}
```

### 4.4 AppDialog.kt（自适应小屏防折行弹窗）
```kotlin
package com.example.ui.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.AlertDialogDefaults
import androidx.compose.material3.BasicAlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.example.ui.theme.AppDimensions
import com.example.ui.theme.AppShapes
import com.example.ui.theme.AppTypography

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppConfirmDialog(
    title: String,
    message: String,
    confirmText: String,
    cancelText: String,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit
) {
    BasicAlertDialog(onDismissRequest = onDismiss) {
        Surface(
            shape = AppShapes.xLarge,
            color = AlertDialogDefaults.containerColor,
            tonalElevation = AlertDialogDefaults.TonalElevation
        ) {
            Column(modifier = Modifier.padding(AppDimensions.spacingXLarge)) {
                Text(text = title, style = AppTypography.titleMedium)
                Spacer(modifier = Modifier.height(AppDimensions.spacingMedium))
                Text(text = message, style = AppTypography.bodyMedium, color = MaterialTheme.colorScheme.onSurfaceVariant)
                Spacer(modifier = Modifier.height(AppDimensions.spacingXLarge))

                // 响应式按钮排列：宽度不足时自适应为纵向，严禁横向文字被挤爆
                BoxWithConstraints(modifier = Modifier.fillMaxWidth()) {
                    if (maxWidth < 280.dp) {
                        Column(
                            modifier = Modifier.fillMaxWidth(),
                            verticalArrangement = Arrangement.spacedBy(AppDimensions.spacingSmall)
                        ) {
                            AppPrimaryButton(text = confirmText, onClick = onConfirm, modifier = Modifier.fillMaxWidth())
                            AppSecondaryButton(text = cancelText, onClick = onDismiss, modifier = Modifier.fillMaxWidth())
                        }
                    } else {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.End
                        ) {
                            AppSecondaryButton(text = cancelText, onClick = onDismiss)
                            Spacer(modifier = Modifier.width(AppDimensions.spacingSmall))
                            AppPrimaryButton(text = confirmText, onClick = onConfirm)
                        }
                    }
                }
            }
        }
    }
}
```

---

## 5. 规范对比与避坑指南（Bad vs Good）

### 场景 1：按钮实现与空间处理
- ❌ **Bad（混乱散乱）**：
  ```kotlin
  Button(
      onClick = { },
      modifier = Modifier.height(47.dp).padding(13.dp), // 随意数值
      shape = RoundedCornerShape(11.dp)                 // 异构圆角
  ) {
      Text("点击此处立即开始检测所有系统模块的运行状态") // 文案过长，小屏自动折成 3 行，按钮被拉高到 80dp
  }
  ```
- ✅ **Good（Stitch 统一规范）**：
  ```kotlin
  AppPrimaryButton(
      text = "开始检测", // 2~4 字精简文案，详细信息置于正文提示
      onClick = { },
      modifier = Modifier.fillMaxWidth() // 铺满容器，高度恒定 48dp，文字单行防溢出
  )
  ```

### 场景 2：卡片与列表结构
- ❌ **Bad（过度碎片化）**：
  ```kotlin
  // 每一个小选项都套一个独立 Card，页面被割裂得支离破碎
  Card { SettingItem1() }
  Spacer(Modifier.height(10.dp))
  Card { SettingItem2() }
  Spacer(Modifier.height(10.dp))
  Card { SettingItem3() }
  ```
- ✅ **Good（统一 Section 分组）**：
  ```kotlin
  AppSection(title = "网络与连接") {
      AppListItem(title = "WLAN", trailing = { AppSwitch(...) })
      AppDivider()
      AppListItem(title = "移动网络", trailing = { AppSwitch(...) })
      AppDivider()
      AppListItem(title = "高级代理", trailing = { ChevronIcon() })
  }
  ```

### 场景 3：色彩硬编码
- ❌ **Bad**：
  ```kotlin
  Text(text = "运行正常", color = Color(0xFF00FF00)) // 硬编码，Dark Mode 下刺眼发白
  ```
- ✅ **Good**：
  ```kotlin
  Text(text = "运行正常", color = MaterialTheme.colorScheme.primary, style = AppTypography.labelMedium)
  ```

---

## 6. 多端与无障碍适配准则

1. **平板与横屏**：页面外层嵌套 `Modifier.widthIn(max = AppDimensions.maxContentWidthExpanded).align(Alignment.CenterHorizontally)`，防止大屏上卡片与输入框横向无限拉伸。
2. **大字号系统（Accessibility 130%~150%）**：
   - 按钮只允许横向自适应宽度或文案截断，**禁止纵向高度撑爆**。
   - 正文与说明文本使用 `Modifier.weight()` 或滚动容器容纳。
3. **触控区域保底**：
   - 所有单图标按钮、Checkbox、Radio 必须保证点击热区 ≥ 48×48dp。
