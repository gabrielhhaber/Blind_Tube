# -*- mode: python ; coding: utf-8 -*-


import os
import shutil
dist="dist/blind_tube"
block_cipher = None


a = Analysis(
    ['blind_tube.pyw'],
    pathex=[],
    binaries=[("_blind_tube.cp313-win_amd64.pyd", ".")],
    datas=[],
    hiddenimports=[
		"timer",
		"language_dict",
	"accessible_output2",
	"cryptography",
	"cryptography.fernet",
	"wx",
"wx.adv",
"wx.lib.newevent",
	"yt_dlp",
	"youtube_transcript_api",
"pynput",
	"pynput.keyboard",
	"psutil",
	"deep_translator",
	"sound_lib.output",
	"sound_lib.stream",
	"google.oauth2",
	"google.oauth2.credentials",
	"google_auth_oauthlib.flow",
	"googleapiclient.discovery",
	"googleapiclient.errors",
"win10toast_click",
"pyperclip",
"feedparser",
"requests",
"dateutil.relativedelta",
"isodate",
"pytz",
"sound_lib",
"google",
"googleapiclient",
	"google_auth_oauthlib",
],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='blind_tube',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='blind_tube',
)
shutil.copy("ffmpeg.exe", dist)
shutil.copy("python.ico", dist)
os.makedirs(dist+"/data", exist_ok=True)
shutil.copy("data/blind_tube_default.ini", dist+"/data/blind_tube_default.ini")
shutil.copy("dicas_de_uso.txt", dist+"/dicas_de_uso.txt")
shutil.copy("novidades.txt", dist+"/novidades.txt")
shutil.copy("tutorial_criação_credencial.txt", dist+"/tutorial_criação_credencial.txt")
shutil.copytree("accessible_output2", dist+"/accessible_output2")
shutil.copytree("sound_lib", dist+"/sound_lib")
shutil.copytree("sounds", dist+"/sounds")