Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class W {
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int n);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT r);
  [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr after, int x, int y, int w, int H, int flags);
  [DllImport("user32.dll")] public static extern int GetSystemMetrics(int idx);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int L, T, R, B; }
}
"@

$proc = Get-Process -Id 37932 -ErrorAction SilentlyContinue
if (-not $proc) { Write-Host "no proc"; exit 1 }
$h = $proc.MainWindowHandle
Write-Host "hwnd: $h  title: $($proc.MainWindowTitle)"

# 屏幕可用区域（去掉任务栏）
$sw = [W]::GetSystemMetrics(0)
$sh = [W]::GetSystemMetrics(1)
Write-Host "screen: $sw x $sh"

# 把窗口摆到屏幕中央
$w = 1280; $H = 720
$x = [int](($sw - $w) / 2)
$y = [int](($sh - $H) / 2)
[void][W]::SetWindowPos($h, [IntPtr]::Zero, $x, $y, $w, $H, 0x0040)
[void][W]::ShowWindow($h, 9)   # SW_RESTORE
Start-Sleep -Milliseconds 300
[void][W]::SetForegroundWindow($h)
Start-Sleep -Milliseconds 1500

# 截取窗口
$r = New-Object W+RECT
[void][W]::GetWindowRect($h, [ref]$r)
$w0 = $r.R - $r.L
$H0 = $r.B - $r.T
Write-Host "window rect: $($r.L),$($r.T) - $($r.R),$($r.B)  size $w0 x $H0"
$bmp = New-Object System.Drawing.Bitmap $w0, $H0
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($r.L, $r.T, 0, 0, [System.Drawing.Size]::new($w0, $H0))
$bmp.Save("D:\it\as\project\volnex\screenshots\app_home_shell.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Host "saved app_home_shell.png"
