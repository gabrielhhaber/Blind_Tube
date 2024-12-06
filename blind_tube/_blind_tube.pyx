import os
import sys
from timer import Timer
import platform
winVersion=platform.release()
import psutil
from glob import glob
from accessible_output2 import outputs
screenReader=outputs.nvda.NVDA()
def speak(text, interrupt=False, onlyOnWindow=False):
	if not onlyOnWindow or app.IsActive():
		screenReader.speak(text, interrupt=interrupt)


import shutil
os.makedirs("logs", exist_ok=True)
sys.stdout=open("logs/stdout.txt", "w")
sys.stderr=open("logs/stderr.txt", "w")
import threading
from threading import Thread
import subprocess
from cryptography.fernet import Fernet
import json
import re
import wx
import wx.adv
app=wx.App()
import locale
locale.setlocale(locale.LC_ALL, "pt_br")
from wx.lib.newevent import NewEvent
class Dialog(wx.Dialog):
	def __init__(self, prevWindow, title, closePrev=True):
		self.prevWindow=prevWindow
		self.closePrev=closePrev
		if closePrev:
			super().__init__(None, title=title, style=wx.DIALOG_NO_PARENT)

		else:
			super().__init__(prevWindow, title=title)


	def Show(self):
		if self.closePrev:
			prevWindow=self.prevWindow
			if prevWindow and prevWindow.IsShown():
				prevWindow.Hide()


		super().Show()


class TextCtrl(wx.TextCtrl):
	def __init__(self, *args, **kwargs):
		if "style" in kwargs:
			kwargs["style"]|=wx.TE_PROCESS_ENTER

		else:
			kwargs["style"]=wx.TE_PROCESS_ENTER

		super().__init__(*args, **kwargs)
		def onEnterPressed(event):
			success, column, line=self.PositionToXY(self.GetInsertionPoint())
			lineText=self.GetLineText(line)
			loweredLineText=lineText.lower()
			if "http" in loweredLineText:
				linkPosition=loweredLineText.find("http")
				link=lineText[linkPosition:]
				speak("Abrindo link...")
				wx.LaunchDefaultBrowser(link)

			else:
				speak("Esta linha do texto não possui nenhum link a abrir")


		self.Bind(wx.EVT_TEXT_ENTER, onEnterPressed)


class List(wx.ListCtrl):
	def __init__(self, parent, title):
		super().__init__(parent, style=wx.LC_REPORT|wx.LC_SINGLE_SEL)
		self.InsertColumn(0, title)

class VideosList(List):
	def __init__(self, parent, title, isChannel=False, isPlaylist=False, supportShortcuts=True, playlistData=None, playlistItems=None):
		super().__init__(parent, title)
		self.parent=parent
		self.title=title
		self.isChannel=isChannel
		self.isPlaylist=isPlaylist
		self.supportShortcuts=supportShortcuts
		self.playlistData=playlistData
		self.playlistItems=playlistItems
		if not self.isChannel:
			self.goToChannel=LinkButton(parent, mainLabel="Ir ao canal do a&utor", isMenu=False)
			self.goToChannel.Disable()

		self.downloadButton=LinkButton(parent, mainLabel="&Baixar vídeo")
		self.downloadButton.Disable()
		def onVideoDownload(event):
			onDownload(event, self.videoData["videoTitle"], self.videoData["id"], self.GetParent(), self)

		self.downloadButton.Bind(wx.EVT_BUTTON, onVideoDownload)
		self.videosData=[]
		self.videoData=None
		def onVideoSelect(event, videosList, videoData, videosData=None, isPlaylist=False, playlistData=None, playlistItems=None):
			speak("Carregando vídeo...")
			currentWindow=videosList.GetParent()
			DmThread(target=window.playVideo, args=(currentWindow, self.videoData, self.videosData, self.isPlaylist, False, self.playlistData, self.playlistItems)).start()

		self.Bind(wx.EVT_LIST_ITEM_ACTIVATED, lambda event: onVideoSelect(event, self, self.videoData, self.videosData, self.isPlaylist))
		if self.supportShortcuts:
			self.Bind(wx.EVT_KEY_DOWN, lambda event: onVideoChar(event, self.videoData))

		def onVideoChange(event):
			self.videoData=getDataByIndex(self, self.videosData)
			if not self.isChannel:
				self.goToChannel.SetNote(self.videoData["channelTitle"])
				self.goToChannel.Enable(True)

			self.downloadButton.Enable(True)

		self.Bind(wx.EVT_LIST_ITEM_FOCUSED, onVideoChange)

	def addVideo(self, videoData):
		if not window.getSetting("fix_names"):
			videoTitle=videoData["videoTitle"]
			channelTitle=videoData["channelTitle"]

		else:
			videoTitle=videoData["videoTitle"].title()
			channelTitle=videoData["channelTitle"].title()

		if videoData["viewCount"]!="1":
			self.Append((f"{videoTitle} postado {getDatesDiferense(videoData['publishedAt'])} por {channelTitle} tem {videoData['viewCount']} visualizações",))

		else:
			self.Append((f"{videoTitle} postado {getDatesDiferense(videoData['publishedAt'])} por {channelTitle} tem {videoData['viewCount']} visualização",))

		self.videosData.append(videoData)

	def clear(self):
		self.DeleteAllItems()
		self.videosData.clear()

from yt_dlp import YoutubeDL
from youtube_transcript_api import YouTubeTranscriptApi
from language_dict import dict as languageDict
languageList = sorted(list(languageDict.keys()))
formatList=["mp4", "mp3", "wav", "ogg", "flac", "m4a"]
from pynput import keyboard
from win10toast_click import ToastNotifier
from traceback import format_exception
import time
import pyperclip
import feedparser
from googletrans import Translator
translator=Translator()
from configparser import ConfigParser
import textwrap
import requests
from zipfile import ZipFile
from datetime import datetime
import pytz
brazilTimezone=pytz.timezone("America/Sao_Paulo")
def convertTimezone(date):
	dateUtc=pytz.utc.localize(date)
	newDate=dateUtc.astimezone(brazilTimezone)
	return newDate

import isodate
import dateutil.relativedelta
import sound_lib
from sound_lib import output, stream
from sound_lib.effects import Tempo

LoadEvent, EVT_LOAD=NewEvent()
VideoEndEvent, EVT_VIDEO_END=NewEvent()
NewVideosEvent, EVT_NEW_VIDEOS=NewEvent()
VideoCloseEvent, EVT_VIDEO_CLOSE=NewEvent()
InstanceEvent, EVT_INSTANCE=NewEvent()
NotifSelectedEvent, EVT_NOTIF_SELECT=NewEvent()
PassEvent, EVT_PASS=NewEvent()
DownloadEvent, EVT_DOWNLOAD=NewEvent()
PercentEvent, EVT_PERCENT=NewEvent()
ConvPercentEvent, EVT_CONV_PERCENT=NewEvent()
UpdaterEvent, EVT_UPDATER=NewEvent()
UpdateEvent, EVT_UPDATE=NewEvent()
ErrorEvent, EVT_ERROR=NewEvent()
MessageEvent, EVT_MESSAGE=NewEvent()
QuotaExceededEvent, EVT_QUOTA_EXCEEDED=NewEvent()
quotaString='"The request cannot be completed because you have exceeded your <a href="/youtube/v3/getting-started#quota">quota</a>."'
portString="[WinError 10048]"
contactEmail="credenciais.blindtube@gmail.com"
def showCredDial():
	credDial=Dialog(None, title="Blind Tube")
	credText=wx.StaticText(credDial, label=f"No momento, você ainda não possui uma credencial de acesso ao Blind Tube. A partir da atualização de julho de 2024, não é mais possível fazer login sem uma credencial própria de acesso. Para solicitar uma, envie um e-mail para {contactEmail} ou, caso seja mais experiente, siga o tutorial de criação de credencial, disponível na pasta do programa com o nome tutorial_criação_de_credencial.txt.")
	copyEmail=wx.Button(credDial, label="&Copiar endereço de e-mail para a área de transferência")
	def onEmailCopy(event):
		pyperclip.copy(contactEmail)
		speak("Endereço de e-mail copiado.")

	copyEmail.Bind(wx.EVT_BUTTON, onEmailCopy)
	ok=wx.Button(credDial, wx.ID_OK, "Ok")
	def onOk(event):
		sys.exit()

	ok.Bind(wx.EVT_BUTTON, onOk)
	credDial.ShowModal()

if not os.path.isfile("credentials.json"):
	showCredDial()

credsFile=open("credentials.json", "r")
credsConfig=json.load(credsFile)
credsFile.close()
def onQuotaExceeded(event):
	quotaDial=Dialog(None, title="Cota de uso excedida", closePrev=False)
	quotaInfo=wx.StaticText(quotaDial, label="Sua cota diária particular de uso do Blind Tube foi excedida. Caso você realize uso mais intenso do programa e necessite de duas credenciais particulares de acesso, entre em contato pelo e-mail credenciais.blindtube@gmail.com, explicando sua necessidade. Clique em ok para fechar o programa.")
	copyEmail=wx.Button(quotaDial, label="&Copiar endereço de e-mail para a área de transferência")
	def onEmailCopy(event):
		pyperclip.copy(contactEmail)
		speak("Endereço de e-mail copiado")

	copyEmail.Bind(wx.EVT_BUTTON, onEmailCopy)
	quotaOk=wx.Button(quotaDial, label="ok")
	def onQuotaOk(event):
		os.remove("token.json")
		killProgram()

	quotaOk.Bind(wx.EVT_BUTTON, onQuotaOk)
	quotaDial.ShowModal()

SendEvent, EVT_SENT=NewEvent()
logedIn=False
def excHandler(type, exception, tb):
	errorName=type.__name__
	errorDescription=str(exception)
	errorDetails=format_exception(type, exception, tb)
	if errorName=="HttpError" and quotaString in errorDescription:
		onQuotaExceeded(None)

	elif errorName=="OSError" and portString in errorDescription:
		wx.MessageBox("Uma outra instância do Blind Tube já estava aguardando o login. Clique em ok para fechar todas as instâncias em execução e, para fazer login, abra o programa novamente.", "Reiniciar o programa", wx.OK|wx.ICON_ERROR)
		killProgram()

	else:
		showError(errorDetails)


def threadExcHandler(args):
	errorName=args.exc_type.__name__
	exception=args.exc_value
	errorDescription=str(exception)
	tb=args.exc_traceback
	errorLine=str(tb.tb_lineno)
	errorDetails=format_exception(type, exception, tb)
	if errorName=="SystemExit":
		return

	elif errorName=="SSLEOFError":
		global yt
		yt=login()
		speak("Seu acesso ao YouTube foi perdido por inatividade, mas você já foi relogado. Tente carregar o conteúdo desejado novamente.")

	elif errorName=="HttpError" and quotaString in errorDescription:
		app.Bind(EVT_QUOTA_EXCEEDED, onQuotaExceeded)
		wx.PostEvent(app, QuotaExceededEvent())

	else:
		app.Bind(EVT_ERROR, lambda event: showError(errorDetails))
		wx.PostEvent(app, ErrorEvent())


def showError(errorDetails):
	errorDial=Dialog(None, title="Erro do Blind Tube", closePrev=False)
	errorBox=TextCtrl(errorDial, style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_DONTWRAP, value="")
	for detail in errorDetails:
		errorBox.AppendText(detail)

	errorBox.SetInsertionPoint(0)
	copyError=wx.Button(errorDial, label="&Copiar texto do erro para a área de transferência")
	def onErrorCopy(event):
		pyperclip.copy(errorBox.GetValue())
		speak("Texto do erro copiado")

	copyError.Bind(wx.EVT_BUTTON, onErrorCopy)
	closeError=wx.Button(errorDial, wx.ID_CANCEL, "Fechar")
	errorDial.ShowModal()

videoSpeeds={
	"0,25x": -75,
	"0,5x": -50,
	"0,75x": -25,
	"1x": 0,
	"1,25x": 25,
	"1,5x": 50,
	"1,75x": 75,
	"2x": 100,
	"2,25x": 125,
	"2,5x": 150,
	"2,75x": 175,
	"3x": 200
}
streamOutput=output.Output()
class DmThread(Thread):
	def __init__(self, *args, **kwargs):
		super().__init__(*args, **kwargs)
		self.daemon=True


from googleapiclient import discovery
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.errors import HttpError
scopes=[
"https://www.googleapis.com/auth/youtube.force-ssl",
]


def openFile(filename):
	file=open(filename, "r", encoding="utf-8")
	try:
		file.read()

	except UnicodeDecodeError:
		file.close()
		file=open(filename, "r", encoding="latin-1")

	else:
		file.seek(0)

	return file

def createFile(fileName):
	if not os.path.isfile(fileName):
		open(fileName, "x").close()


def killProgram():
	taskkillInfo=subprocess.STARTUPINFO()
	taskkillInfo.dwFlags=subprocess.STARTF_USESHOWWINDOW
	execName=os.path.basename(sys.executable)
	taskkillString=f"taskkill /f /im {execName}"
	subprocess.Popen(taskkillString, startupinfo=taskkillInfo)
	sys.exit()

def getParentWindow(currentObject):
	while not isinstance(currentObject, wx.Frame) and not isinstance(currentObject, wx.Dialog) and not isinstance(currentObject, Dialog):
		currentObject=currentObject.GetParent()
		if not currentObject:
			return None


	return currentObject

def focused(controlClass, parentWindow):
	for child in parentWindow.GetChildren():
		if isinstance(child, controlClass) and child.HasFocus():
			return True

	return False

def getVideoData(video):
	publishedAtOriginal=video["snippet"]["publishedAt"]
	publishedAt=datetime.strptime(publishedAtOriginal, "%Y-%m-%dT%H:%M:%SZ")
	publishedAt=convertTimezone(publishedAt)
	baseUrl="https://www.youtube.com/watch?v="
	durationOriginal=video["contentDetails"]["duration"]
	duration=isodate.parse_duration(durationOriginal)
	totalSeconds=duration.seconds
	durationString=durationToString(totalSeconds)
	likeString=likesToString(video["statistics"].get("likeCount"))
	videoData={
		"id": video["id"],
		"url": baseUrl+video["id"],
		"videoTitle": video["snippet"]["title"],
		"channelTitle": video["snippet"]["channelTitle"],
		"channelId": video["snippet"]["channelId"],
		"channelUrl": baseUrl+video["id"],
		"viewCount": video["statistics"].get("viewCount", "0"),
		"likeCount": video["statistics"].get("likeCount"),
		"likeString": likeString,
		"commentCount": video["statistics"].get("commentCount"),
		"publishedAtOriginal": publishedAtOriginal,
		"publishedAt": publishedAt,
		"durationOriginal": durationOriginal,
		"duration": duration,
		"durationSeconds": str(totalSeconds),
		"durationString": durationString,
		"description": video["snippet"].get("description", "Este vídeo não possui descrição."),
	}
	return videoData

def getCommentData(comment, commentThread, videoData):
	publishedAtOriginal=comment["snippet"]["publishedAt"]
	publishedAt=datetime.strptime(publishedAtOriginal, "%Y-%m-%dT%H:%M:%SZ")
	publishedAt=convertTimezone(publishedAt)
	likeString=likesToString(comment["snippet"]["likeCount"])
	commentData={
"id": comment["id"],
"authorName": comment["snippet"]["authorDisplayName"].strip(),
"authorId": comment["snippet"]["authorChannelId"]["value"],
"channelTitle": videoData["channelTitle"],
"channelId": videoData["channelId"],
"originalText": comment["snippet"]["textDisplay"],
"userRating": comment["snippet"]["viewerRating"],
"likeCount": comment["snippet"]["likeCount"],
"likeString": likeString,
"replyCount": commentThread["snippet"]["totalReplyCount"],
"publishedAt": publishedAt,
"isTruncate": False,
	}
	mainReplies=commentThread.get("replies", {"comments": []})
	for reply in mainReplies["comments"]:
		authorId=reply["snippet"]["authorChannelId"]["value"]
		ownerId=videoData["channelId"]
		if authorId==ownerId:
			ownerReplied=True
			break


	else:
		ownerReplied=False

	commentData["ownerReplied"]=ownerReplied
	commentData=truncateIfNecessary(commentData)
	return commentData

def getReplyData(reply, commentData):
	publishedAtOriginal=reply["snippet"]["publishedAt"]
	publishedAt=datetime.strptime(publishedAtOriginal, "%Y-%m-%dT%H:%M:%SZ")
	publishedAt=convertTimezone(publishedAt)
	likeString=likesToString(reply["snippet"]["likeCount"])
	replyData={
			"authorName": reply["snippet"]["authorDisplayName"],
			"authorId": reply["snippet"]["authorChannelId"]["value"],
			"channelId": commentData["channelId"],
			"originalText": reply["snippet"]["textDisplay"],
			"likeCount": reply["snippet"]["likeCount"],
			"likeString": likeString,
			"publishedAt": publishedAt,
			"isFromOwner": False,
	}
	authorId=replyData["authorId"]
	ownerId=replyData["channelId"]
	if authorId==ownerId:
		replyData["isFromOwner"]=True

	replyData=truncateIfNecessary(replyData)
	return replyData

def formatComment(text, width=140):
	return textwrap.fill(text, width=width, break_long_words=False)

def truncateIfNecessary(commentData, maxCharacters=140):
	if len(commentData["originalText"])<=maxCharacters:
		commentData["text"]=commentData["originalText"]
	else:
		commentData["text"]=commentData["originalText"][:140]+"..."
		commentData["isTruncate"]=True

	return commentData

def fixHandles(originalText, isReply=False, replaceNumbers=True):
	if not originalText.startswith("@"):
		return originalText

	fixedText=originalText
	atExp="(?<!@)@(?!@)"
	if not isReply:
		fixedText=re.sub(atExp, "", fixedText, 1)

	else:
		fixedText=fixedText.replace("@@", "@")

	numbersExp="((?<=[a-zA-Z-_])[\d]+$|(?<=[a-zA-Z-_])[\d]+(?=\s))"
	if replaceNumbers:
		fixedText=re.sub(numbersExp, "", fixedText, 1)

	return fixedText

def endsWithPunctuation(string):
	punctuationList=[",", ".", ";", "!", "?", ":"]
	for simbol in punctuationList:
		if string.endswith(simbol):
			return True


	return False

def getPlaylistData(playlist):
	playlistData={
		"id": playlist["id"],
		"title": playlist["snippet"]["title"],
		"description": playlist["snippet"]["description"],
		"itemCount": playlist["contentDetails"]["itemCount"],
	}
	return playlistData

def getChannelData(channel):
	createdAtOriginal=channel["snippet"]["publishedAt"]
	microssecondsExp="\.[0-9]+"
	createdAtOriginal=re.sub(microssecondsExp, "", createdAtOriginal)
	createdAt=datetime.strptime(createdAtOriginal, "%Y-%m-%dT%H:%M:%SZ")
	createdAt=convertTimezone(createdAt)
	channelData={
		"id": channel["id"],
		"channelTitle": channel["snippet"]["title"],
		"about": channel["snippet"].get("description", "Este canal não possui descrição"),
		"createdAt": createdAt,
		"videoCount": channel["statistics"]["videoCount"],
		"subscriberCount": subsToString(channel["statistics"]["subscriberCount"]),
	}
	for subscription in window.allSubs.get("items", []):
		channelId=subscription["snippet"]["resourceId"]["channelId"]
		if channelId==channelData["id"]:
			channelData["isSubscribed"]=True
			channelData["subscriptionId"]=subscription["id"]
			break


	else:
		channelData["isSubscribed"]=False

	return channelData

def addPlaylist(list, playlistData):
	if playlistData["itemCount"]!=1:
		list.Append(("{} ({} vídeos)".format(playlistData["title"], playlistData["itemCount"]),))

	else:
		list.Append(("{} ({} vídeo)".format(playlistData["title"], playlistData["itemCount"]),))


def addFeedVideo(list, videoData):
	if not window.getSetting("fix_names"):
		videoTitle=videoData["videoTitle"]
		channelTitle=videoData["channelTitle"]

	else:
		videoTitle=videoData["videoTitle"].title()
		channelTitle=videoData["channelTitle"].title()

	list.Append((f"{channelTitle} enviou o vídeo {videoTitle} - {getDatesDiferense(videoData['publishedAt'])}",))
	list.videosData.append(videoData)

def addChannel(list, channelData):
	if not window.getSetting("fix_names"):
		channelTitle=channelData["channelTitle"]

	else:
		channelTitle=channelData["channelTitle"].title()

	if channelData["subscriberCount"]!="1" and channelData["videoCount"]!="1":
		list.Append((f"{channelTitle} tem {channelData['subscriberCount']} inscritos e {channelData['videoCount']} vídeos",))

	elif channelData["subscriberCount"]=="1" and channelData["videoCount"]!="1":
		list.Append((f"{channelTitle} tem {channelData['subscriberCount']} inscrito e {channelData['videoCount']} vídeos",))

	elif channelData["subscriberCount"]!="1" and channelData["videoCount"]=="1":
		list.Append((f"{channelTitle} tem {channelData['subscriberCount']} inscritos e {channelData['videoCount']} vídeo",))

	else:
		list.Append((f"{channelTitle} tem {channelData['subscriberCount']} inscrito e {channelData['videoCount']} vídeo",))


def onSubscribe(event, channelData):
	subscribeButton=event.GetEventObject()
	if not channelData["isSubscribed"]:
		speak("Inscrevendo...")
		subscription=yt.subscriptions().insert(
			part="snippet",
			body={
				"snippet": {
					"resourceId": {
						"channelId": channelData["id"],
					}
				}
			}).execute()
		window.mainSubs["items"].insert(0, subscription)
		window.allSubs["items"].insert(0, subscription)
		channelData["isSubscribed"]=True
		channelData["subscriptionId"]=subscription["id"]
		window.playSound("subscribed")
		speak("Alerta inscrição adicionada", interrupt=True)
		subscribeButton.SetLabel(f"Cancelar &inscrição de {channelData['channelTitle']}")

	else:
		speak("Cancelando inscrição...")
		subscription=yt.subscriptions().delete(id=channelData["subscriptionId"]).execute()
		channelData["isSubscribed"]=False
		for subscription in window.allSubs.get("items", []):
			if subscription["id"]==channelData["subscriptionId"]:
				window.allSubs["items"].remove(subscription)
				if subscription in window.mainSubs["items"]:
					window.mainSubs["items"].remove(subscription)



		speak("Alerta inscrição cancelada", interrupt=True)
		subscribeButton.SetLabel(f"&Inscreva-se em {channelData['channelTitle']}")

def UrlIsValid(videoUrl):
	urlExp="(http(s)?://)?(www\.)?(youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/|youtube\.com/v/)[a-zA-Z0-9-_]{11}"
	urlValid=re.match(urlExp, videoUrl, re.I)
	if urlValid:
		return True

	return False

def loadPlaylist(currentWindow, playlistData):
	playlistItems=yt.playlistItems().list(part="snippet,status", playlistId=playlistData["id"], maxResults=50).execute()
	videoIds=[]
	for playlistItem in playlistItems.get("items", []):
		if playlistItem["status"]["privacyStatus"]=="private":
			continue

		videoIds.append(playlistItem["snippet"]["resourceId"]["videoId"])

	videoIdsStr=joinIds(videoIds)
	videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoIdsStr).execute()
	currentWindow.Bind(EVT_LOAD, onPlaylistLoaded)
	wx.PostEvent(currentWindow, LoadEvent(currentWindow=currentWindow, videos=videos, playlistData=playlistData, playlistItems=playlistItems))

def onPlaylistLoaded(event):
	currentWindow=event.currentWindow
	videos=event.videos
	playlistData=event.playlistData
	playlistItems=event.playlistItems
	playlistDial=Dialog(currentWindow, title="Playlist "+playlistData["title"])
	playlistClose=wx.Button(playlistDial, wx.ID_CANCEL, "Voltar")
	playlistClose.Bind(wx.EVT_BUTTON, onWindowClose)
	videosLabel=wx.StaticText(playlistDial, label="&Vídeos da playlist")
	videosList=VideosList(playlistDial, title="Vídeos da playlist", isPlaylist=True, playlistData=playlistData, playlistItems=playlistItems)
	videosList.SetFocus()
	videosData=[]
	for video in videos.get("items", []):
		videoData=getVideoData(video)
		videosData.append(videoData)
		videosList.addVideo(videoData)

	downloadPlaylist=LinkButton(playlistDial, mainLabel="Bai&xar playlist")
	def onPlaylistDownload(event):
		downloadDial=Dialog(playlistDial, title="Baixar playlist", closePrev=False)
		folderLabel=wx.StaticText(downloadDial, label="&Pasta para salvar os vídeos (será criada uma pasta com o nome da playlist dentro dela)")
		folderBox=TextCtrl(downloadDial, style=wx.TE_DONTWRAP)
		defaultFolder=window.getSettingOrigin("download_folder")
		defaultFormat=window.getSettingOrigin("default_format")
		folderBox.SetValue(defaultFolder)
		formatLabel=wx.StaticText(downloadDial, label="&Formato dos vídeos")
		formatBox=wx.ComboBox(downloadDial, choices=formatList, value=defaultFormat)
		confirmButton=wx.Button(downloadDial, label="&Baixar")
		cancelButton=wx.Button(downloadDial, wx.ID_CANCEL, "&Cancelar")
		cancelButton.Bind(wx.EVT_BUTTON, onWindowClose)
		def onConfirm(event):
			folder=folderBox.GetValue()
			if folder and not os.path.isdir(folder):
				if not wantToCreate(folder):
					return


			playlistTitle=fixChars(playlistData["title"])
			newFolder=os.path.join(folder, playlistTitle)
			os.makedirs(newFolder, exist_ok=True)
			format=formatBox.GetValue()
			window.downloadCanceled=False
			window.videosWithError=[]
			downloadingDial=Dialog(downloadDial, title="Baixando playlist", closePrev=False)
			downloadProgress=wx.Gauge(downloadingDial)
			def onPercentChange(event):
				downloadProgress.SetValue(event.percentage)

			window.Bind(EVT_PERCENT, onPercentChange)
			def onConvPercentChange(event):
				downloadProgress.SetValue(event.percentage)

			window.Bind(EVT_CONV_PERCENT, onConvPercentChange)
			cancelDownload=wx.Button(downloadingDial, label="&Cancelar")
			def onCancel(event):
				window.downloadCanceled=True
				downloadingDial.Destroy()
				downloadDial.Destroy()

			cancelDownload.Bind(wx.EVT_BUTTON, onCancel)

			def onDownloadsCompleted(event):
				window.playSound("downloaded")
				if window.videosWithError:
					warningDial=Dialog(downloadingDial, title="Aviso", closePrev=False)
					warningText=wx.StaticText(warningDial, label="Alguns vídeos desta playlist não puderam ser baixados. Isso pode ter ocorrido devido a problemas de conexão, ou algo relacionado a esses vídeos específicos. Se desejar tentar baixá-los novamente, clique em baixar playlist ao fechar este diálogo.")
					warningBoxText=wx.StaticText(warningDial, label="Vídeos não baixados")
					warningBox=TextCtrl(warningDial, style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_DONTWRAP)
					window.addListItems(warningBox, window.videosWithError)
					warningClose=wx.Button(warningDial, wx.ID_CANCEL, "fechar")
					warningDial.ShowModal()

				downloadingDial.Destroy()
				downloadDial.Destroy()

			window.Bind(EVT_DOWNLOAD, onDownloadsCompleted)
			def getPlaylistVideos():
				videoResults=yt.playlistItems().list(part="snippet,status", playlistId=playlistData["id"], maxResults=50).execute()
				downloadVideos(videoResults, format, newFolder)
				while "nextPageToken" in videoResults and videoResults["nextPageToken"]:
					videoResults=yt.playlistItems().list(part="snippet,status", playlistId=playlistData["id"], maxResults=50, pageToken=videoResults["nextPageToken"]).execute()
					downloadVideos(videoResults, format, newFolder)

				if not window.downloadCanceled:
					wx.PostEvent(window, DownloadEvent())


			window.playSound("downloading")
			DmThread(target=getPlaylistVideos).start()
			downloadingDial.Show()

		folderBox.Bind(wx.EVT_TEXT_ENTER, onConfirm)
		formatBox.Bind(wx.EVT_TEXT_ENTER, onConfirm)
		confirmButton.Bind(wx.EVT_BUTTON, onConfirm)
		downloadDial.Show()

	downloadPlaylist.Bind(wx.EVT_BUTTON, onPlaylistDownload)
	loadMore=wx.Button(playlistDial, label="&Carregar mais")
	if not "nextPageToken" in playlistItems:
		loadMore.Disable()

	def onLoadMore(event):
		speak("Carregando mais...")
		def loadMoreItems():
			nextPageToken=playlistItems["nextPageToken"]
			newPlaylistItems=yt.playlistItems().list(part="snippet,status", playlistId=playlistData["id"], maxResults=50, pageToken=nextPageToken).execute()
			videoIds=[]
			for playlistItem in newPlaylistItems.get("items", []):
				videoIds.append(playlistItem["snippet"]["resourceId"]["videoId"])

			videoIdsStr=joinIds(videoIds)
			newVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoIdsStr).execute()
			playlistDial.Bind(EVT_LOAD, onMoreItemsLoaded)
			wx.PostEvent(playlistDial, LoadEvent(newVideos=newVideos, newPlaylistItems=newPlaylistItems))

		DmThread(target=loadMoreItems).start()
		def onMoreItemsLoaded(event):
			nonlocal playlistItems
			nonlocal videos
			playlistItems=event.newPlaylistItems
			videos=event.newVideos
			for video in videos.get("items", []):
				videoData=getVideoData(video)
				videosData.append(videoData)
				videosList.addVideo(videoData)

			speak("Vídeos carregados.")
			if not "nextPageToken" in playlistItems:
				speak("Fim dos vídeos.")
				loadMore.Disable()
				videosList.SetFocus()



	loadMore.Bind(wx.EVT_BUTTON, onLoadMore)
	def onNewVideosAdded(event):
		videosData=event.videosData
		playlistItems=event.playlistItems
		for videoData in videosData:
			videosList.addVideo(videoData)

		if not "nextPageToken" in playlistItems:
			loadMore.Disable()


	playlistDial.Bind(EVT_NEW_VIDEOS, onNewVideosAdded)
	def onVideoClosed(event):
		videoPos=event.videoPos
		videosList.Focus(videoPos)

	playlistDial.Bind(EVT_VIDEO_CLOSE, onVideoClosed)
	playlistDial.Show()

def loadChannel(channelId, currentWindow):
	channelResults=yt.channels().list(part="id,snippet,statistics", id=channelId).execute()
	channel=channelResults["items"][0]
	channelData=getChannelData(channel)
	newDate=datetime.now()
	newDate=convertTimezone(newDate)
	newDateString=isodate.strftime(newDate, "%Y-%m-%dT%H:%M:%SZ")
	prevDate=newDate-dateutil.relativedelta.relativedelta(months=6)
	prevDateString=isodate.strftime(prevDate, "%Y-%m-%dT%H:%M:%SZ")
	videoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedAfter=prevDateString).execute()
	videoIds=[]
	for result in videoResults.get("items", []):
		videoIds.append(result["id"]["videoId"])

	videoIdsStr=joinIds(videoIds)
	videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoIdsStr).execute()
	while not len(videoResults["items"])>=10:
		newDate=prevDate
		newDateString=prevDateString
		prevDate=newDate-dateutil.relativedelta.relativedelta(months=6)
		prevDateString=isodate.strftime(prevDate, "%Y-%m-%dT%H:%M:%SZ")
		if (prevDate.year<channelData["createdAt"].year) or (prevDate.year==channelData["createdAt"].year and prevDate.month<channelData["createdAt"].month):
			break

		moreVideoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedAfter=prevDateString, publishedBefore=newDateString).execute()
		moreVideoIds=[]
		for result in moreVideoResults.get("items", []):
			moreVideoIds.append(result["id"]["videoId"])

		moreVideoIdsStr=joinIds(moreVideoIds)
		moreVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=moreVideoIdsStr).execute()
		videoResults["items"].extend(moreVideoResults["items"])
		videoResults["nextPageToken"]=moreVideoResults.get("nextPageToken")
		videos["items"].extend(moreVideos["items"])

	currentWindow.Bind(EVT_LOAD, onChannelLoaded)
	wx.PostEvent(currentWindow, LoadEvent(currentWindow=currentWindow, videos=videos, videoResults=videoResults, channelData=channelData, newDate=newDate, newDateString=newDateString, prevDate=prevDate, prevDateString=prevDateString))

def onChannelLoaded(event):
	videos=event.videos
	videoResults=event.videoResults
	sortMethod="date"
	searchTerm=""
	channelData=event.channelData
	newDate=event.newDate
	newDateString=event.newDateString
	prevDate=event.prevDate
	prevDateString=event.prevDateString
	videosData=[]
	channelId=channelData["id"]
	currentWindow=event.currentWindow
	if not window.getSetting("fix_names"):
		channelTitle=channelData["channelTitle"]

	else:
		channelTitle=channelData["channelTitle"].title()

	channelDial=Dialog(currentWindow, title=channelTitle)
	channelClose=wx.Button(channelDial, wx.ID_CANCEL, "Voltar")
	channelClose.Bind(wx.EVT_BUTTON, onWindowClose)
	videosLabel=wx.StaticText(channelDial, label="&Vídeos do canal")
	videosList=VideosList(channelDial, title="&Vídeos do canal", isChannel=True)
	videosList.SetFocus()
	for video in videos.get("items", []):
		try:
			videoData=getVideoData(video)

		except Exception:
			continue

		videosData.append(videoData)
		videosList.addVideo(videoData)

	infoLabel=wx.StaticText(channelDial, label="In&formações")
	infoBox=TextCtrl(channelDial, style=wx.TE_READONLY|wx.TE_MULTILINE|wx.TE_DONTWRAP)
	if channelData["subscriberCount"]!="1":
		infoBox.AppendText(channelData["subscriberCount"]+" inscritos")

	else:
		infoBox.AppendText(channelData["subscriberCount"]+" inscrito")

	if channelData["videoCount"]!="1":
		infoBox.AppendText(f"\n{channelData['videoCount']} vídeos")

	else:
		infoBox.AppendText(f"\n{channelData['videoCount']} vídeo")

	publishedAtString=channelData["createdAt"].strftime("%d/%m/%Y, às %#H:%M.")
	infoBox.AppendText(f"\nCriado em: {publishedAtString}")
	infoBox.SetInsertionPoint(0)
	searchLabel=wx.StaticText(channelDial, label="&Pesquisar no canal")
	searchBox=TextCtrl(channelDial, style=wx.TE_DONTWRAP)
	def onChannelSearch(event):
		speak("Pesquisando...")
		def searchChannel():
			nonlocal searchTerm
			searchTerm=searchBox.GetValue()
			if searchTerm:
				searchResults=yt.search().list(part="id", q=searchTerm, channelId=channelData["id"], type="video", maxResults=50, order="relevance").execute()

			else:
				searchResults=yt.search().list(part="id", channelId=channelData["id"], q="", type="video", maxResults=50, order=sortMethod).execute()

			videoIds=[]
			for result in searchResults.get("items", []):
				videoIds.append(result["id"]["videoId"])

			videoIdsStr=joinIds(videoIds)
			videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoIdsStr).execute()
			channelDial.Bind(EVT_LOAD, onSearchLoaded)
			wx.PostEvent(channelDial, LoadEvent(searchResults=searchResults, videos=videos))

		DmThread(target=searchChannel).start()
		def onSearchLoaded(event):
			videosList.clear()
			for video in event.videos.get("items", []):
				try:
					videoData=getVideoData(video)

				except Exception:
					continue

				videosData.append(videoData)
				videosList.addVideo(videoData)

			speak("Pesquisa carregada")
			searchBox.Clear()
			videosList.SetFocus()


	searchBox.Bind(wx.EVT_TEXT_ENTER, onChannelSearch)
	loadMoreButton=wx.Button(channelDial, label="&Carregar mais")
	def onLoadMore(event):
		speak("Carregando mais...")
		def loadMore():
			nonlocal newDate
			nonlocal newDateString
			nonlocal prevDate
			nonlocal prevDateString
			if sortMethod=="date" and not searchTerm:
				if "nextPageToken" in videoResults and videoResults["nextPageToken"]:
					nextPageToken=videoResults["nextPageToken"]
					newVideoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedAfter=prevDateString, publishedBefore=newDateString, pageToken=nextPageToken).execute()
					newVideoIds=[]
					for result in newVideoResults.get("items", []):
						newVideoIds.append(result["id"]["videoId"])

					newVideoIdsStr=joinIds(newVideoIds)
					newVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=newVideoIdsStr).execute()

				else:
					newDate=prevDate
					newDateString=prevDateString
					prevDate=newDate-dateutil.relativedelta.relativedelta(months=6)
					prevDateString=isodate.strftime(prevDate, "%Y-%m-%dT%H:%M:%SZ")
					newVideoResults=yt.search().list(part="id", channelId=channelId, q=searchTerm, type="video", order="date", maxResults=50, publishedAfter=prevDateString, publishedBefore=newDateString).execute()
					newVideoIds=[]
					for result in newVideoResults.get("items", []):
						newVideoIds.append(result["id"]["videoId"])

					newVideoIdsStr=joinIds(newVideoIds)
					newVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=newVideoIdsStr).execute()
					while not len(newVideoResults["items"])>=10:
						newDate=prevDate
						newDateString=prevDateString
						prevDate=newDate-dateutil.relativedelta.relativedelta(months=6)
						prevDateString=isodate.strftime(prevDate, "%Y-%m-%dT%H:%M:%SZ")
						if (prevDate.year<channelData["createdAt"].year) or (prevDate.year==channelData["createdAt"].year and prevDate.month<channelData["createdAt"].month):
							if newVideoResults["items"]:
								break

							else:
								speak("Não há mais vídeos a serem carregados")
								loadMoreButton.Disable()
								return


						moreVideoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedAfter=prevDateString, publishedBefore=newDateString).execute()
						moreVideoIds=[]
						for result in moreVideoResults.get("items", []):
							moreVideoIds.append(result["id"]["videoId"])

						moreVideoIdsStr=joinIds(moreVideoIds)
						moreVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=moreVideoIdsStr).execute()
						newVideoResults["items"].extend(moreVideoResults["items"])
						newVideoResults["nextPageToken"]=moreVideoResults.get("nextPageToken")
						newVideos["items"].extend(moreVideos["items"])



			elif sortMethod=="reverseDate" and not searchTerm:
				prevDate=newDate
				newDate=prevDate+dateutil.relativedelta.relativedelta(months=6)
				newDateString=isodate.strftime(newDate, "%Y-%m-%dT%H:%M:%SZ")
				newVideoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedBefore=newDateString, publishedAfter=prevDateString).execute()
				newVideoIds=[]
				for result in newVideoResults.get("items", []):
					newVideoIds.append(result["id"]["videoId"])

				newVideoIdsStr=joinIds(newVideoIds)
				newVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=newVideoIdsStr).execute()
				while not len(newVideoResults["items"])>=10:
					prevDate=newDate
					newDate=prevDate+dateutil.relativedelta.relativedelta(months=6)
					newDateString=isodate.strftime(newDate, "%Y-%m-%dT%H:%M:%SZ")
					currentDate=datetime.now()
					if (newDate.year>currentDate.year) or (newDate.year==currentDate.year and newDate.month>currentDate.month):
						if newVideoResults["items"]:
							break

						else:
							speak("Não há mais vídeos a serem carregados")
							loadMoreButton.Disable()
							return


					moreVideoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedBefore=newDateString, published_after=prevDateString).execute()
					moreVideoIds=[]
					for result in moreVideoResults.get("items", []):
						moreVideoIds.append(result["id"]["videoId"])

					moreVideoIdsStr=joinIds(moreVideoIds)
					moreVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=moreVideoIdsStr).execute()
					newVideoResults["items"].extend(moreVideoResults["items"])
					newVideoResults["nextPageToken"]=moreVideoResults.get("nextPageToken")
					newVideos["items"].extend(moreVideos["items"])

				while "nextPageToken" in newVideoResults and newVideoResults["nextPageToken"]:
					nextPageToken=newVideoResults["nextPageToken"]
					moreVideoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedAfter=prevDateString, publishedBefore=newDateString, pageToken=nextPageToken).execute()
					moreVideoIds=[]
					for result in moreVideoResults.get("items", []):
						moreVideoIds.append(result["id"]["videoId"])

					moreVideoIdsStr=joinIds(moreVideoIds)
					moreVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=moreVideoIdsStr).execute()
					newVideoResults["items"].extend(moreVideoResults["items"])
					newVideoResults["nextPageToken"]=moreVideoResults.get("nextPageToken")
					newVideos["items"].extend(moreVideos["items"])

				newVideoResults["items"].reverse()
				newVideos["items"].reverse()

			else:
				if searchTerm:
					newVideoResults=yt.search().list(part="id", channelId=channelId, q=searchTerm, type="video", order="date", maxResults=50).execute()

				else:
					newVideoResults=yt.search().list(part="id", channelId=channelId, type="video", order=sortMethod, maxResults=50, pageToken=videoResults["nextPageToken"]).execute()

				newVideoIds=[]
				for result in newVideoResults.get("items", []):
					newVideoIds.append(result["id"]["videoId"])

				newVideoIdsStr=joinIds(newVideoIds)
				newVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=newVideoIdsStr).execute()


			channelDial.Bind(EVT_LOAD, onNewVideosLoaded)
			wx.PostEvent(channelDial, LoadEvent(newVideos=newVideos, newVideoResults=newVideoResults))

		DmThread(target=loadMore).start()
		def onNewVideosLoaded(event):
			newVideos=event.newVideos
			newVideoResults=event.newVideoResults
			nonlocal videoResults
			videoResults=newVideoResults
			for video in newVideos.get("items", []):
				try:
					videoData=getVideoData(video)

				except Exception:
					continue

				videosData.append(videoData)
				videosList.addVideo(videoData)

			speak("Vídeos carregados.")
			if sortMethod=="date":
				if newDate.year<channelData["createdAt"].year or newDate.year==channelData["createdAt"].year and newDate.month<channelData["createdAt"].month:
					speak("Fim dos vídeos")
					loadMoreButton.Disable()



	loadMoreButton.Bind(wx.EVT_BUTTON, onLoadMore)
	sortBy=LinkButton(channelDial, mainLabel="&Ordenar por: mais recente")
	def onSort(event):
		if searchTerm:
			wx.MessageBox("Não é possível ordenar os vídeos no momento porque você está no modo de pesquisa. Para voltar ao modo padrão, pressione alt+p ou vá para o campo de pesquisa e pressione enter, deixando-o em branco.", "Não é possível ordenar", wx.OK|wx.ICON_ERROR, channelDial)
			return

		sortMenu=wx.Menu()
		recent=sortMenu.Append(1, "Mais &recente")
		popular=sortMenu.Append(2, "Mais &populares")
		old=sortMenu.Append(3, "Mais &antigo")
		def sort(sortMethod):
			nonlocal newDate
			nonlocal newDateString
			nonlocal prevDate
			nonlocal prevDateString
			videosList.clear()
			if sortMethod=="date":
				newDate=datetime.now()
				newDate=convertTimezone(newDate)
				newDateString=isodate.strftime(newDate, "%Y-%m-%dT%H:%M:%SZ")
				prevDate=newDate-dateutil.relativedelta.relativedelta(months=6)
				prevDateString=isodate.strftime(prevDate, "%Y-%m-%dT%H:%M:%SZ")
				videoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedAfter=prevDateString).execute()
				videoIds=[]
				for result in videoResults.get("items", []):
					videoIds.append(result["id"]["videoId"])

				videoIdsStr=joinIds(videoIds)
				videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoIdsStr).execute()
				while not len(videoResults["items"])>=10:
					newDate=prevDate
					newDateString=prevDateString
					prevDate=newDate-dateutil.relativedelta.relativedelta(months=6)
					prevDateString=isodate.strftime(prevDate, "%Y-%m-%dT%H:%M:%SZ")
					if (prevDate.year<channelData["createdAt"].year) or (prevDate.year==channelData["createdAt"].year and prevDate.month<channelData["createdAt"].month):
						break

					moreVideoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedAfter=prevDateString, publishedBefore=newDateString).execute()
					moreVideoIds=[]
					for result in moreVideoResults.get("items", []):
						moreVideoIds.append(result["id"]["videoId"])

					moreVideoIdsStr=joinIds(moreVideoIds)
					moreVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=moreVideoIdsStr).execute()
					videoResults["items"].extend(moreVideoResults["items"])


			elif sortMethod=="reverseDate":
				prevDate=channelData["createdAt"]
				prevDateString=isodate.strftime(prevDate, "%Y-%m-%dT%H:%M:%SZ")
				newDate=prevDate+dateutil.relativedelta.relativedelta(months=6)
				newDateString=isodate.strftime(newDate, "%Y-%m-%dT%H:%M:%SZ")
				videoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedBefore=newDateString).execute()
				videoIds=[]
				for result in videoResults.get("items", []):
					videoIds.append(result["id"]["videoId"])

				videoIdsStr=joinIds(videoIds)
				videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoIdsStr).execute()
				while not len(videoResults["items"])>=10:
					prevDate=newDate
					newDate=prevDate+dateutil.relativedelta.relativedelta(months=6)
					newDateString=isodate.strftime(newDate, "%Y-%m-%dT%H:%M:%SZ")
					currentDate=datetime.now()
					if (newDate.year>currentDate.year) or (newDate.year==currentDate.year and newDate.month>currentDate.month):
						break

					moreVideoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedBefore=newDateString, publishedAfter=prevDateString).execute()
					moreVideoIds=[]
					for result in moreVideoResults.get("items", []):
						moreVideoIds.append(result["id"]["videoId"])

					moreVideoIdsStr=joinIds(moreVideoIds)
					moreVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=moreVideoIdsStr).execute()
					videoResults["items"].extend(moreVideoResults["items"])
					videoResults["nextPageToken"]=moreVideoResults.get("nextPageToken")
					videos["items"].extend(moreVideos["items"])

				while "nextPageToken" in videoResults and videoResults["nextPageToken"]:
					nextPageToken=videoResults["nextPageToken"]
					newVideoResults=yt.search().list(part="id", channelId=channelId, type="video", order="date", maxResults=50, publishedAfter=prevDateString, publishedBefore=newDateString, pageToken=nextPageToken).execute()
					newVideoIds=[]
					for result in newVideoResults.get("items", []):
						newVideoIds.append(result["id"]["videoId"])

					newVideoIdsStr=joinIds(newVideoIds)
					newVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=newVideoIdsStr).execute()
					videoResults["items"].extend(newVideoResults["items"])
					videoResults["nextPageToken"]=newVideoResults.get("nextPageToken")
					videos["items"].extend(newVideos["items"])

				videoResults["items"].reverse()
				videos["items"].reverse()

			else:
				videoResults=yt.search().list(part="id", channelId=channelId, q=searchTerm, type="video", order=sortMethod, maxResults=50).execute()
				videoIds=[]
				for result in videoResults.get("items", []):
					videoIds.append(result["id"]["videoId"])

				videoIdsStr=joinIds(videoIds)
				videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoIdsStr).execute()

			channelDial.Bind(EVT_LOAD, onSortLoaded)
			wx.PostEvent(channelDial, LoadEvent(sortedVideos=videos))

		def onSortSelected(event):
			nonlocal sortMethod
			loadMoreButton.Enable(True)
			itemId=event.GetId()
			menuItem=sortMenu.FindItemById(itemId)
			if itemId==1:
				sortMethod="date"

			elif itemId==2:
				sortMethod="viewCount"

			else:
				sortMethod="reverseDate"

			itemLabel=menuItem.GetItemLabelText()
			sortBy.SetLabel("&Ordenar por: "+itemLabel)
			if sortMethod=="date" or sortMethod=="viewCount":
				DmThread(target=sort, args=(sortMethod,)).start()

			else:
				DmThread(target=sort, args=("reverseDate",)).start()


		sortMenu.Bind(wx.EVT_MENU, onSortSelected)
		def onSortLoaded(event):
			videos=event.sortedVideos
			for video in videos.get("items", []):
				videoData=getVideoData(video)
				videosData.append(videoData)
				videosList.addVideo(videoData)

			speak("Alerta vídeos ordenados.", interrupt=True)
			videosList.SetFocus()

		channelDial.PopupMenu(sortMenu)

	sortBy.Bind(wx.EVT_BUTTON, onSort)
	if not channelData["isSubscribed"]:
		subscribe=wx.Button(channelDial, label=f"&Inscreva-se em {channelData['channelTitle']}")

	else:
		subscribe=wx.Button(channelDial, label=f"Cancelar &inscrição de {channelData['channelTitle']}")

	subscribe.Bind(wx.EVT_BUTTON, lambda event: onSubscribe(event, channelData))
	aboutLabel=wx.StaticText(channelDial, label="&Sobre este canal")
	aboutBox=TextCtrl(channelDial, style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_DONTWRAP, value=channelData["about"])
	showPlaylists=LinkButton(channelDial, mainLabel="Play&lists")
	def onPlaylists(event):
		speak("Carregando playlists...")
		def loadChannelPlaylists():
			playlists=yt.playlists().list(part="id,snippet,contentDetails", channelId=channelData["id"], maxResults=50).execute()
			channelDial.Bind(EVT_LOAD, onPlaylistsLoaded)
			wx.PostEvent(channelDial, LoadEvent(playlists=playlists, channelData=channelData))

		DmThread(target=loadChannelPlaylists).start()
		def onPlaylistsLoaded(event):
			playlists=event.playlists
			channelData=event.channelData
			playlistsDial=Dialog(channelDial, title="Playlists de "+channelData["channelTitle"])
			playlistsClose=wx.Button(playlistsDial, wx.ID_CANCEL, "Voltar")
			playlistsClose.Bind(wx.EVT_BUTTON, onWindowClose)
			playlistsLabel=wx.StaticText(playlistsDial, label="&Playlists")
			playlistsList=List(playlistsDial, title="Playlists")
			playlistsList.SetFocus()
			playlistsData=[]
			for playlist in playlists.get("items", []):
				playlistData=getPlaylistData(playlist)
				playlistsData.append(playlistData)
				addPlaylist(playlistsList, playlistData)

			def onPlaylistSelected(event):
				speak("Carregando playlist...")
				item=event.GetIndex()
				playlistData=playlistsData[item]
				DmThread(target=loadPlaylist, args=(playlistsDial, playlistData,)).start()

			playlistsList.Bind(wx.EVT_LIST_ITEM_ACTIVATED, onPlaylistSelected)

			loadMore=wx.Button(playlistsDial, label="&Carregar mais")
			if not "nextPageToken" in playlists:
				loadMore.Disable()

			def onLoadMore(event):
				speak("Carregando mais...")
				def loadMorePlaylists():
					nextPageToken=playlists["nextPageToken"]
					newPlaylists=yt.playlists().list(part="id,snippet,contentDetails", channelId=channelData["id"], maxResults=50, pageToken=nextPageToken).execute()
					playlistsDial.Bind(EVT_LOAD, onMorePlaylistsLoaded)
					wx.PostEvent(playlistsDial, LoadEvent(newPlaylists=newPlaylists))

				DmThread(target=loadMorePlaylists).start()
				def onMorePlaylistsLoaded(event):
					nonlocal playlists
					playlists=event.newPlaylists
					for playlist in playlists.get("items", []):
						playlistData=getPlaylistData(playlist)
						playlistsData.append(playlistData)
						addPlaylist(playlistsList, playlistData)

					speak("Playlists carregadas.", interrupt=True)
					if not "nextPageToken" in playlists:
						speak("Fim das playlists.")
						loadMore.Disable()
						playlistsList.SetFocus()


			loadMore.Bind(wx.EVT_BUTTON, onLoadMore)
			playlistsDial.Show()

	showPlaylists.Bind(wx.EVT_BUTTON, onPlaylists)
	channelSettings=LinkButton(channelDial, mainLabel="Co&nfigurações do canal")
	def onChannelSettings(event):
		channelId=channelData["id"]
		channelSetDial=Dialog(channelDial, title="Configurações do canal "+channelData["channelTitle"])
		defaultSpeedLabel=wx.StaticText(channelSetDial, label="Velocidad&e padrão para os vídeos do canal")
		speedsList=["Padrão"]+list(videoSpeeds.keys())
		defaultSpeedBox=wx.ComboBox(channelSetDial, choices=speedsList, style=wx.CB_READONLY)
		speedValue=window.getChannelSettingOrigin("default_speed", channelId)
		if speedValue=="default":
			defaultSpeedBox.SetValue("Padrão")

		else:
			defaultSpeedBox.SetValue(speedValue)

		notifBox=wx.CheckBox(channelSetDial, label="Ativar &notificações de novos vídeos para este canal (se inscrito)")
		notifBox.SetValue(window.getChannelSetting("notifications", channelId))
		transcriptLanguageLabel = wx.StaticText(channelSetDial, label="Idioma para as trans&crições de vídeos do canal")
		channelLanguageList = ["Padrão"] + languageList
		transcriptLanguageBox = wx.ComboBox(channelSetDial, choices=channelLanguageList, style=wx.CB_READONLY)
		languageCode = window.getChannelSettingOrigin("default_transcript_language", channelId)
		if languageCode == "default":
			languageName = "Padrão"

		else:
			languageName = list(languageDict.keys())[list(languageDict.values()).index(languageCode)]

		transcriptLanguageBox.SetStringSelection(languageName)
		ok=wx.Button(channelSetDial, wx.ID_OK, "Ok")
		def onOk(event):
			if not window.conf.has_section(channelId):
				window.conf.add_section(channelId)

			newSpeedValue=defaultSpeedBox.GetValue()
			if newSpeedValue=="Padrão":
				window.setChannelSettingOrigin("default_speed", "default", channelId)

			else:
				window.setChannelSettingOrigin("default_speed", newSpeedValue, channelId)

			window.setChannelSetting("notifications", notifBox.GetValue(), channelId)
			newTranscriptLanguage = transcriptLanguageBox.GetValue()
			if newTranscriptLanguage == "Padrão":
				window.setChannelSettingOrigin("default_transcript_language", "default", channelId)

			else:
				window.setChannelSettingOrigin("default_transcript_language", languageDict[newTranscriptLanguage], channelId)

			with open("blind_tube.ini", "w") as configFile:
				window.conf.write(configFile)

			onWindowClose(event)

		ok.Bind(wx.EVT_BUTTON, onOk)
		cancel=wx.Button(channelSetDial, wx.ID_CANCEL, "Cancelar")
		cancel.Bind(wx.EVT_BUTTON, onWindowClose)
		channelSetDial.Show()

	channelSettings.Bind(wx.EVT_BUTTON, onChannelSettings)
	downloadChannel=LinkButton(channelDial, mainLabel="Bai&xar canal")
	def onChannelDownload(event):
		downloadDial=Dialog(channelDial, title="Baixar canal", closePrev=False)
		folderLabel=wx.StaticText(downloadDial, label="&Pasta para salvar os vídeos (será criada uma pasta com o nome do canal dentro dela)")
		folderBox=TextCtrl(downloadDial, style=wx.TE_DONTWRAP)
		defaultFolder=window.getSettingOrigin("download_folder")
		folderBox.SetValue(defaultFolder)
		defaultFormat=window.getSettingOrigin("default_format")
		formatLabel=wx.StaticText(downloadDial, label="&Formato dos vídeos")
		formatBox=wx.ComboBox(downloadDial, choices=formatList, value=defaultFormat)
		confirmButton=wx.Button(downloadDial, label="&Baixar")
		cancelButton=wx.Button(downloadDial, wx.ID_CANCEL, "&Cancelar")
		cancelButton.Bind(wx.EVT_BUTTON, onWindowClose)
		def onConfirm(event):
			folder=folderBox.GetValue()
			if folder and not os.path.isdir(folder):
				if not wantToCreate(folder):
					return


			channelTitle=fixChars(channelData["channelTitle"])
			newFolder=os.path.join(folder, channelTitle)
			os.makedirs(newFolder, exist_ok=True)
			format=formatBox.GetValue()
			window.downloadCanceled=False
			window.videosWithError=[]
			downloadingDial=Dialog(downloadDial, title="Baixando canal", closePrev=False)
			downloadProgress=wx.Gauge(downloadingDial)
			def onPercentChange(event):
				downloadProgress.SetValue(event.percentage)

			window.Bind(EVT_PERCENT, onPercentChange)
			def onConvPercentChange(event):
				downloadProgress.SetValue(event.percentage)

			window.Bind(EVT_CONV_PERCENT, onConvPercentChange)
			cancelDownload=wx.Button(downloadingDial, label="&Cancelar")
			def onCancel(event):
				window.downloadCanceled=True
				downloadingDial.Destroy()
				downloadDial.Destroy()

			cancelDownload.Bind(wx.EVT_BUTTON, onCancel)
			def onDownloadsCompleted(event):
				window.playSound("downloaded")
				if window.videosWithError:
					warningDial=Dialog(downloadingDial, title="Aviso", closePrev=False)
					warningText=wx.StaticText(warningDial, label="Alguns vídeos deste canal não puderam ser baixados. Isso pode ter ocorrido devido a problemas de conexão, ou a algum problema com esses vídeos específicos. Se desejar tentar baixá-los novamente, clique em baixar canal ao fechar este diálogo.")
					warningBoxText=wx.StaticText(warningDial, label="Vídeos não baixados")
					warningBox=TextCtrl(warningDial, style=wx.TE_READONLY|wx.TE_MULTILINE|wx.TE_DONTWRAP)
					window.addListItems(warningBox, window.videosWithError)
					warningClose=wx.Button(warningDial, wx.ID_CANCEL, "fechar")
					warningDial.ShowModal()

				downloadingDial.Destroy()
				downloadDial.Destroy()

			window.Bind(EVT_DOWNLOAD, onDownloadsCompleted)
			def getChannelVideos():
				newDate=datetime.now()
				newDate=convertTimezone(newDate)
				newDateString=isodate.strftime(newDate, "%Y-%m-%dT%H:%M:%SZ")
				prevDate=newDate-dateutil.relativedelta.relativedelta(months=6)
				prevDateString=isodate.strftime(prevDate, "%Y-%m-%dT%H:%M:%SZ")
				while True:
					if (prevDate.year<channelData["createdAt"].year) or (prevDate.year==channelData["createdAt"].year and prevDate.month<channelData["createdAt"].month):
						break

					videoResults=yt.search().list(part="id,snippet", channelId=channelData["id"], type="video", order="date", maxResults=50, publishedAfter=prevDateString, publishedBefore=newDateString).execute()
					if videoResults["items"]:
						downloadVideos(videoResults, format, newFolder)
						while "nextPageToken" in videoResults and videoResults["nextPageToken"]:
							videoResults=yt.search().list(part="id,snippet", channelId=channelData["id"], type="video", order="date", maxResults=50, publishedAfter=prevDateString, publishedBefore=newDateString, pageToken=videoResults["nextPageToken"]).execute()
							downloadVideos(videoResults, format, newFolder)


					newDate=prevDate
					prevDate=newDate-dateutil.relativedelta.relativedelta(months=6)

				if not window.downloadCanceled:
					wx.PostEvent(window, DownloadEvent())


			window.playSound("downloading")
			DmThread(target=getChannelVideos).start()
			downloadingDial.Show()

		folderBox.Bind(wx.EVT_TEXT_ENTER, onConfirm)
		formatBox.Bind(wx.EVT_TEXT_ENTER, onConfirm)
		confirmButton.Bind(wx.EVT_BUTTON, onConfirm)
		downloadDial.Show()

	downloadChannel.Bind(wx.EVT_BUTTON, onChannelDownload)
	channelDial.Show()

def getDataByIndex(list, dataList):
	item=list.GetFocusedItem()
	return dataList[item]

def durationToString(totalSeconds):
	minutes=totalSeconds//60
	seconds=totalSeconds%60
	hours=totalSeconds//3600
	string=""
	if hours==0:
		if minutes==1:
			string+=f"{minutes} minuto"

		else:
			string+=f"{minutes} minutos"

		if seconds==1:
			string+=f" e {seconds} segundo"

		else:
			string+=f" e {seconds} segundos"

	else:
		if hours==1:
			string+=f"{hours} hora"

		else:
			string+=f"{hours} horas"

		onlyMins=minutes%60
		if onlyMins==1:
			string+=f", {onlyMins} minuto"

		else:
			string+=f", {onlyMins} minutos"

		if seconds==1:
			string+=f" e {seconds} segundo"

		else:
			string+=f" e {seconds} segundos"


	return string

def posToSeconds(duration):
	if duration.count(":")==2:
		hour, minute, second=duration.split(":")

	else:
		hour=0; minute, second=duration.split(":")

	totalSeconds=int(hour)*3600+int(minute)*60+int(second)
	return totalSeconds

def dateToString(date):
	dateString=datetime.strftime(date, "%d/%m/%Y, às %#H:%M")
	return dateString

def changePlaces(n1, n2, decimalPlaces):
	decimalString=str(n1/n2)
	decimalString=decimalString.replace(".", ",")
	commaPosition=decimalString.find(",")
	endPosition=commaPosition+decimalPlaces+1
	decimalString=decimalString[:endPosition]
	return decimalString

def subsToString(originalString):
	if originalString is None:
		return None

	number=int(originalString)
	if number>=100000000 and number<1000000000:
		string=str(number//1000000)+" milhões de"

	elif number>=10000000 and number<100000000:
		string=changePlaces(number, 1000000, 1)+" milhões de"

	elif number>=1000000 and number<1010000:
		string=str(number//1000000)+" milhão de"

	elif number>=1000000 and number<10000000:
		string=changePlaces(number, 1000000, 2)+" milhões de"

	elif number>=100000 and number<1000000:
		string=str(number//1000)+" mil"

	elif number>=10000 and number<100000:
		string=changePlaces(number, 1000, 2)+" mil"

	elif number>=1000 and number<10000:
		string=changePlaces(number, 1000, 2)+" mil"

	else:
		string=str(number)

	return string

def likesToString(originalString):
	if originalString is None:
		return None

	number=int(originalString)
	if number>=100000000 and number<1000000000:
		string=str(number//1000000)+" milhões de"

	elif number>=10000000 and number<100000000:
		string=changePlaces(number, 1000000, 1)+" milhões de"

	elif number>=1000000 and number<1010000:
		string=str(number//1000000)+" milhão de"

	elif number>=1000000 and number<10000000:
		string=changePlaces(number, 1000000, 1)+" milhões de"

	elif number>=100000 and number<1000000:
		string=str(number//1000)+" mil"

	elif number>=10000 and number<100000:
		string=changePlaces(number, 1000, 1)+" mil"

	elif number>=1000 and number<10000:
		string=changePlaces(number, 1000, 1)+" mil"

	else:
		string=str(number)

	return string

def joinIds(idsList):
	return ",".join(idsList)

def fixChars(string):
	invalidChars=["/", "*", "?", ":", "|", ".", "…", "\"", "(", ")", "-", "&"]
	for char in invalidChars:
		string=string.replace(char, "")

	return string

def getDatesDiferense(newDate):
	currentDate=datetime.now()
	currentDate=currentDate.astimezone(brazilTimezone)
	dif=currentDate-newDate
	second=int(dif.total_seconds())
	minute=second//60
	hour=minute//60
	day=hour//24
	month=day//30
	year=month//12
	if year>1:
		difStr=f"há {year} anos"
	elif year==1:
		difStr="há 1 ano"
	elif month>1:
		difStr=f"há {month} meses"
	elif month==1:
		difStr="há 1 mês"
	elif day>1:
		difStr=f"há {day} dias"
	elif day==1:
		difStr="há 1 dia"
	elif hour>1:
		difStr=f"há {hour} horas"
	elif hour==1:
		difStr="Há uma hora"
	elif minute>1:
		difStr=f"há {minute} minutos"
	elif minute==1:
		difStr="há 1 minuto"
	elif second>1:
		difStr=f"há {second} segundos"
	elif second==1:
		difStr="há 1 segundo"
	else:
		difStr="agora"

	return difStr

def onWindowClose(event):
	currentObject=event.GetEventObject()
	objectToClose=getParentWindow(currentObject)
	objectToClose.Destroy()
	if not wx.GetKeyState(wx.WXK_ALT):
		prevObject=objectToClose.prevWindow
		if not prevObject.IsShown():
			prevObject.Show()

def onVideoChar(event, videoData):
	currentWindow=getParentWindow(event.GetEventObject())
	keyCode=event.GetKeyCode()
	if wx.GetKeyState(wx.WXK_CONTROL):
		if videoData==None:
			event.Skip()
			return

		if keyCode==ord("P"):
			publishedAt=videoData["publishedAt"]
			publishedAtString=dateToString(publishedAt)
			speak(f"Publicado em {publishedAtString}")

		elif keyCode==ord("U"):
			speak(videoData["durationString"])

		elif keyCode==ord("L"):
			if videoData["likeCount"]:
				if videoData["likeCount"]!="1":
					speak(f"{videoData['likeCount']} marcações gostei")

				else:
					speak(f"{videoData['likeCount']} marcação gostei")


			else:
				speak("Este canal ocultou a quantidade de marcações gostei.")


		elif keyCode==ord("C"):
			if not focused(TextCtrl, currentWindow):
				if videoData["commentCount"]:
					if videoData["commentCount"]!="1":
						speak(f"{videoData['commentCount']} comentários")

					else:
						speak(f"{videoData['commentCount']} comentário")


				else:
					speak("Este vídeo está com os comentários desativados.")


			else:
				event.Skip()


		elif keyCode==ord("K"):
			videoLink=videoData["url"]
			pyperclip.copy(videoLink)
			speak("Link do vídeo copiado.")

		elif keyCode==ord("I"):
			if videoData["viewCount"]!="1":
				speak(f"{videoData['viewCount']} visualizações")

			else:
				speak(f"{videoData['viewCount']} visualização")


		elif keyCode==ord("A"):
			if not focused(TextCtrl, currentWindow):
				speak(f"{videoData['channelTitle']}")

			else:
				event.Skip()


		elif keyCode==ord("T"):
			if not window.getSetting("fix_names"):
				videoTitle=videoData["videoTitle"]

			else:
				videoTitle=videoData["videoTitle"].title()

			if not wx.GetKeyState(wx.WXK_SHIFT):
				speak(videoTitle)

			else:
				pyperclip.copy(videoTitle)
				speak("Título do vídeo copiado:")


		else:
			event.Skip()


	else:
		event.Skip()


def startDownload(url, filePath, convertPath, format, videoId, sendEvent=True):
	videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoId).execute()
	video=videos["items"][0]
	videoData=getVideoData(video)
	def onProgressChange(dict):
		if window.downloadCanceled:
				sys.exit()

		elif dict["status"]=="downloading":
			percentageStr=dict["_percent_str"].replace("%", "")
			percentage=int(float(percentageStr))
			wx.PostEvent(window, PercentEvent(percentage=percentage))

		elif dict["status"]=="finished":
			if not format=="mp4":
				speak("Iniciando conversão para "+format, interrupt=True, onlyOnWindow=True)
				ffString='ffmpeg.exe'
				ffString+=f' -i "{filePath}"'
				ffString+=' -y'
				ffString+=' -ab 128k'
				ffString+=" -vn"
				ffString+=f' "{convertPath}"'
				ffInfo=subprocess.STARTUPINFO()
				ffInfo.dwFlags=subprocess.STARTF_USESHOWWINDOW
				ffProcess=subprocess.Popen(ffString, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, startupinfo=ffInfo)
				ffRunning=True
				wrongPercent=False
				videoSeconds=int(videoData["durationSeconds"])
				totalFileSize=videoSeconds*16
				while ffRunning:
					if window.downloadCanceled:
						ffProcess.kill()
						sys.exit()

					output=ffProcess.stdout.readline()
					if ffProcess.poll() is None or output:
						if "size=" in output:
							sizeExp="(?<=size=)[\s]*[\d]+(?=kB)"
							sizeString=re.search(sizeExp, output).group()
							sizeString=sizeString.strip()
							convertPercent=int(sizeString)*100//totalFileSize
							if not window.downloadCanceled:
								if convertPercent<=100:
									wx.PostEvent(window, ConvPercentEvent(percentage=convertPercent))




					else:
						ffRunning=False

					time.sleep(0.05)

				os.remove(filePath)

			if not window.downloadCanceled and sendEvent:
				wx.PostEvent(window, DownloadEvent())




	ytdl=YoutubeDL({
		"format": "mp4",
		"quiet": True,
		"progress_hooks": [onProgressChange],
		"outtmpl": filePath,
			})
	ytdl.download(url)

def wantToCreate(folder):
	answer=wx.MessageBox("A pasta especificada para o download não existe. Deseja criá-la?", "Pasta inexistente", wx.YES_NO|wx.ICON_QUESTION)
	if answer==wx.YES:
		os.makedirs(folder, exist_ok=True)
		return True

	return False

def downloadVideos(videoResults, format, folder):
	for result in videoResults.get("items", []):
		if window.downloadCanceled:
			sys.exit()

		if result["kind"]=="youtube#searchResult":
			videoId=result["id"]["videoId"]
			videoTitle=result["snippet"]["title"]

		elif result["kind"]=="youtube#playlistItem":
			if result["status"]["privacyStatus"]=="private":
				continue

			videoId=result["snippet"]["resourceId"]["videoId"]
			videoTitle=result["snippet"]["title"]

		videoTitle=fixChars(videoTitle)
		url=baseUrl+videoId
		filePath=os.path.join(folder, videoTitle+".mp4")
		convertPath=filePath.replace(".mp4", "."+format)
		speak("Baixando vídeo: "+videoTitle, interrupt=True, onlyOnWindow=True)
		try:
			startDownload(url, filePath, convertPath, format, videoId, sendEvent=False)

		except Exception:
			speak("Não foi possível baixar este vídeo: "+videoTitle)
			window.videosWithError.append(videoTitle)
			time.sleep(1)

def onDownload(event, videoTitle, videoId, currentWindow, listToFocus=None):
	videoTitle=fixChars(videoTitle)
	downloadDial=Dialog(currentWindow, title="Baixar vídeo", closePrev=False)
	folderLabel=wx.StaticText(downloadDial, label="&Pasta para salvar o arquivo (deixe em branco para salvar na pasta do programa)")
	folderBox=TextCtrl(downloadDial, style=wx.TE_DONTWRAP)
	defaultFolder=window.getSettingOrigin("download_folder")
	folderBox.SetValue(defaultFolder)
	defaultFormat=window.getSettingOrigin("default_format")
	formatLabel=wx.StaticText(downloadDial, label="&Formato do arquivo")
	formatBox=wx.ComboBox(downloadDial, choices=formatList, value=defaultFormat)
	nameLabel=wx.StaticText(downloadDial, label="&Nome do arquivo (sem o caminho da pasta)")
	nameBox=TextCtrl(downloadDial, style=wx.TE_PROCESS_ENTER|wx.TE_DONTWRAP)
	nameBox.SetValue(videoTitle)
	confirmButton=wx.Button(downloadDial, wx.ID_OK, "&Baixar")
	cancelButton=wx.Button(downloadDial, wx.ID_CANCEL, "&Cancelar")
	cancelButton.Bind(wx.EVT_BUTTON, onWindowClose)
	def onConfirm(event):
		folder=folderBox.GetValue()
		if folder and not os.path.isdir(folder):
			if not wantToCreate(folder):
				return


		format=formatBox.GetValue()
		window.downloadCanceled=False
		if nameBox.IsEmpty():
			nameBox.SetValue(videoTitle)
			wx.MessageBox("O nome do arquivo salvo não pode estar em branco, e foi preenchido automaticamente com o título original do vídeo. Caso queira salvá-lo com outro nome, feche esta mensagem e vá ao campo de edição nome do arquivo.", "Nome de arquivo em branco", style=wx.OK|wx.ICON_WARNING, parent=downloadDial)
			return

		fileName=nameBox.GetValue()
		if "." in fileName:
			dotPosition=fileName.Find(".")
			fileName=fileName[:dotPosition]

		fileName+=".mp4"
		filePath=os.path.join(folder, fileName)
		convertPath=filePath.replace(".mp4", "."+format)
		if os.path.isfile(convertPath):
			wantToReplace=wx.MessageBox("Já há um arquivo com este mesmo nome e formato na pasta especificada. Deseja realizar o download mesmo assim e substituir o arquivo?", "Arquivo já existente", wx.YES_NO|wx.ICON_QUESTION, parent=downloadDial)
			if wantToReplace==wx.NO:
				return


		url=baseUrl+videoId
		downloadingDial=Dialog(downloadDial, title="Baixando vídeo", closePrev=False)
		downloadProgress=wx.Gauge(downloadingDial)
		def onPercentChange(event):
			downloadProgress.SetValue(event.percentage)

		window.Bind(EVT_PERCENT, onPercentChange)
		def onConvPercentChange(event):
			downloadProgress.SetValue(event.percentage)

		window.Bind(EVT_CONV_PERCENT, onConvPercentChange)
		def onDownloadFinished(event):
			window.playSound("downloaded")
			downloadingDial.Destroy()
			downloadDial=downloadingDial.prevWindow
			downloadDial.Destroy()
			if listToFocus:
				listToFocus.SetFocus()


		window.Bind(EVT_DOWNLOAD, onDownloadFinished)
		cancelDownload=wx.Button(downloadingDial, label="&Cancelar")
		def onCancel(event):
			window.downloadCanceled=True
			downloadingDial.Destroy()
			downloadDial.Destroy()
			currentWindow.Show()
			if listToFocus:
				listToFocus.SetFocus()


		cancelDownload.Bind(wx.EVT_BUTTON, onCancel)
		window.playSound("downloading")
		DmThread(target=startDownload, args=(url, filePath, convertPath, format, videoId)).start()
		downloadingDial.Show()

	folderBox.Bind(wx.EVT_TEXT_ENTER, onConfirm)
	formatBox.Bind(wx.EVT_TEXT_ENTER, onConfirm)
	nameBox.Bind(wx.EVT_TEXT_ENTER, onConfirm)
	confirmButton.Bind(wx.EVT_BUTTON, onConfirm)
	downloadDial.Show()


class AccessibleSearch(wx.Accessible):
	def GetDescription(self, childId):
		return (wx.ACC_OK, "Pressione a seta para baixo para ver o histórico")


class AccessibleSlider(wx.Accessible):
	def __init__(self, stream):
		super().__init__()
		self.stream=stream

	def GetValue(self, childId):
		return (wx.ACC_OK, self.stream.sliderString)


class AccessibleLinkButton(wx.Accessible):
	def GetRole(self, childId):
		if childId==0:
			return (wx.ACC_OK, wx.ROLE_SYSTEM_BUTTONMENU)


class LinkButton(wx.adv.CommandLinkButton):
	def __init__(self, parent, mainLabel, note="", isMenu=True):
		super().__init__(parent, mainLabel=mainLabel, note=note)
		if isMenu:
			self.SetAccessible(AccessibleLinkButton())



class VideoStream(Tempo):
	def __init__(self, *args, **kwargs):
		videoStream=stream.URLStream(*args, **kwargs)
		super().__init__(videoStream)
		self.sliderString=""
		self.isLoaded=True

def login():
	creds=None
	if os.path.isfile("token.json") and os.path.isfile("credentials.json"):
		tokenMSecs=os.path.getmtime("token.json")
		tokenMDate=datetime.fromtimestamp(tokenMSecs)
		credsMSecs=os.path.getmtime("credentials.json")
		credsMDate=datetime.fromtimestamp(credsMSecs)
		if credsMDate>tokenMDate:
			wx.MessageBox("Parece que você recebeu uma nova credencial de acesso. Pressione enter para desfazer seu login atual e se autenticar novamente.", "Nova credencial detectada", wx.OK|wx.ICON_WARNING)
			os.remove("token.json")


	if os.path.isfile("token.json"):
		tokenMSecs=os.path.getmtime("token.json")
		tokenMDate=datetime.fromtimestamp(tokenMSecs)
		changeDate=datetime.strptime("20/09/2023", "%d/%m/%Y")
		if tokenMDate<changeDate:
			wx.MessageBox("A partir desta atualização, todos os tokens de autenticação criados antes de 20/09/2023 deverão ser atualizados. Clique em ok para excluir seu token atual.", "Renovação de token", wx.OK|wx.ICON_WARNING)
			os.remove("token.json")

		else:
			tokensKey=b"LpV6PLj8zQVa0GMNu_i8GQA346Ku4zkzPZK1EqrLpQw="
			encrypFile=open("token.json", "rb")
			tokenLines=[]
			for line in encrypFile:
				tokenLines.append(line.strip())

			encrypFile.close()
			encrypter=Fernet(tokensKey)
			token=encrypter.decrypt(tokenLines[0]).decode("ascii")
			refreshToken=encrypter.decrypt(tokenLines[1]).decode("ascii")
			tokenUri=credsConfig["installed"]["token_uri"]
			clientId=credsConfig["installed"]["client_id"]
			clientSecret=credsConfig["installed"]["client_secret"]
			expiry=tokenLines[2].decode("ascii")
			jsonToken={
				"token": token,
				"refresh_token": refreshToken,
				"token_uri": tokenUri,
				"client_id": clientId,
				"client_secret": clientSecret,
				"scopes": scopes,
				"expiry": expiry,
			}


			creds=Credentials.from_authorized_user_info(jsonToken, scopes)
			del jsonToken

			del encrypter
			del tokensKey

	if not creds or not creds.valid:
		if creds and creds.expired and creds.refresh_token:
			creds.refresh(Request())

		else:
			wx.MessageBox("Pressione enter para abrir seu navegador e fazer login em sua conta do YouTube.", "Você não está autenticado", wx.OK)
			flow=InstalledAppFlow.from_client_secrets_file("credentials.json", scopes)
			creds=flow.run_local_server(port=8083, success_message="A autenticação foi concluída com sucesso. Você pode fechar esta guia.")

		originToken=creds.to_json()
		tokensKey=b"LpV6PLj8zQVa0GMNu_i8GQA346Ku4zkzPZK1EqrLpQw="
		encrypter=Fernet(tokensKey)
		originJsonToken=json.loads(originToken)
		jsonToken={}
		for key, value in originJsonToken.items():
			if isinstance(value, str):
				jsonToken[key]=value.encode("ascii")

			else:
				jsonToken[key]=json.dumps(value).encode("ascii")


		token=encrypter.encrypt(jsonToken["token"])
		refreshToken=encrypter.encrypt(jsonToken["refresh_token"])
		expiry=jsonToken["expiry"]
		encrypToken=token+b"\n"+refreshToken+b"\n"+expiry
		encrypFile=open("token.json", "wb")
		encrypFile.write(encrypToken)
		encrypFile.close()
		del tokensKey
		del originToken
		del token
		del refreshToken
		del encrypter

	yt=discovery.build("youtube", "v3", credentials=creds, static_discovery=False)
	del creds
	return yt

baseUrl="https://www.youtube.com/watch?v="
class MainWindow(wx.Dialog):
	def __init__(self, parent, title, instanceData=None):
		super().__init__(parent, title=title, style=wx.DIALOG_NO_PARENT)
		self.appName="Blind_Tube"+wx.GetUserId()
		self.currentVersion="21/11/2024"
		self.instanceChecker=wx.SingleInstanceChecker(self.appName)
		self.instanceData=instanceData
		if self.instanceData:
			self.mainSubs=self.instanceData["mainSubs"]
			self.allSubs=self.instanceData["allSubs"]

		else:
			self.mainSubs=self.getMainSubs()
			self.allSubs=self.getAllSubs()

			self.removeOldVersionFiles()
		self.isFirstInstance=not self.instanceChecker.IsAnotherRunning()
		self.isNotifying=False
		self.notifsLoaded=False
		self.loadSettings()
		if not self.instanceData:
			self.notifList=[]
			self.checkNotifications()

		self.isCheckingUpdates=False
		if self.isFirstInstance:
			if self.getSetting("check_updates"):
				self.startUpdateCheck()

			self.createHotkey()
			self.hotkeyChecker.start()

		self.initUi()

	def loadSettings(self):
		if not os.path.isfile("blind_tube.ini"):
			shutil.copy("data/blind_tube_default.ini", "blind_tube.ini")

		if not self.instanceData:
			self.conf=ConfigParser()
			self.conf.read("blind_tube.ini")

		else:
			self.conf=self.instanceData["conf"]

		self.defaultConf=ConfigParser()
		self.defaultConf.read("data/blind_tube_default.ini")
		self.defaultChannelConf={
			"default_speed": "default",
			"notifications": "on",
			"default_transcript_language": "default",
		}

	def getMainSubs(self):
		subscriptions=yt.subscriptions().list(part="id,snippet", maxResults=25, mine=True).execute()
		return subscriptions

	def getAllSubs(self):
		allSubs={
			"items": []
		}
		subscriptions=yt.subscriptions().list(part="id,snippet", maxResults=25, mine=True).execute()
		allSubs["items"].extend(subscriptions["items"])
		while "nextPageToken" in subscriptions:
			subscriptions=yt.subscriptions().list(part="id,snippet", maxResults=25, pageToken=subscriptions["nextPageToken"], mine=True).execute()
			allSubs["items"].extend(subscriptions["items"])

		return allSubs

	def checkNotifications(self):
		def checkVideos():
			self.isNotifying=True
			toaster=ToastNotifier()
			createFile("data/notifieds.txt")
			currentIteration=1
			while True:
				for index, subscription in enumerate(self.allSubs.get("items", [])):
					channelId=subscription["snippet"]["resourceId"]["channelId"]
					shouldNotify=self.getChannelSetting("notifications", channelId)
					if not shouldNotify:
						continue

					while True:
						try:
							feed=feedparser.parse(f"https://www.youtube.com/feeds/videos.xml?channel_id={channelId}")

						except Exception:
							time.sleep(5)

						else:
							break


					for entry in feed["entries"]:
						videoData=self.getFeedData(entry)
						currentDate=datetime.now()
						currentDate=currentDate.astimezone(brazilTimezone)
						datesDiferense=currentDate-videoData["publishedAt"]
						daysDiferense=datesDiferense.days
						hoursDiferense=datesDiferense.seconds//3600
						if daysDiferense>=30:
							continue

						if not videoData in self.notifList:
							self.notifList.append(videoData)

						notifiedsFile=open("data/notifieds.txt", "r")
						alreadyNotified=videoData["id"]+"\n" in notifiedsFile
						notifiedsFile.close()
						if alreadyNotified:
							continue

						notifiedsFile=open("data/notifieds.txt", "a")
						notifiedsFile.write(videoData["id"]+"\n")
						notifiedsFile.close()

						if daysDiferense>0 or hoursDiferense>0:
							continue

						if self.getSetting("notifications") and self.isFirstInstance:
							if self.getSettingOrigin("notif_method")=="system":
								toaster.show_toast(title=videoData["channelTitle"], msg=videoData["videoTitle"], icon_path="python.ico", duration=10, callback_on_click=lambda: self.onNotifClicked(videoData))

							else:
								self.notifiedVideo=videoData["id"]
								self.playSound("notification")
								notifMessage=f"Novo vídeo de {videoData['channelTitle']}: {videoData['videoTitle']}"
								if self.getSetting("notif_shortcut") and not endsWithPunctuation(videoData["videoTitle"]):
									notifMessage+="."

								if self.getSetting("notif_shortcut"):
									notifMessage+=" Pressione ctrl+shift+n para abrir o vídeo"

								speak(notifMessage)



					if currentIteration>1:
						time.sleep(3)

					else:
						time.sleep(0.05)

					if index-1 == int(self.getSettingOrigin("max_channels")):
						break


				currentIteration+=1
				if currentIteration==2:
					self.notifsLoaded=True


			self.isNotifying=False

		self.notifiedVideo=None
		if not self.isNotifying:
			DmThread(target=checkVideos).start()


	def startUpdateCheck(self):
		checkUrl="https://blind-center.com.br/downloads/blind_tube/bt_update.json"
		def onUpdaterEvent(event):
			versionString=event.siteVersion.replace("/s", "")
			wantToUpdate=wx.MessageBox("Uma nova atualização do Blind Tube está disponível. Ela foi lançada em "+versionString+". Deseja baixá-la e instalá-la agora? Ao instalar a atualização, todas as instâncias atuais do Blind Tube serão fechadas.", "Atualização do Blind Tube", wx.YES_NO|wx.ICON_QUESTION, self)
			if wantToUpdate==wx.YES:
				self.update()


		self.Bind(EVT_UPDATER, onUpdaterEvent)
		def checkUpdates():
			self.isCheckingUpdates=True
			while self.getSetting("check_updates"):
				try:
					updateFile=requests.get(checkUrl)

				except Exception:
					pass

				else:
					try:
						versionInfo=json.loads(updateFile.text)
						self.siteVersion=versionInfo["version"]
						if self.currentVersion!=self.siteVersion:
							wx.PostEvent(self, UpdaterEvent(siteVersion=self.siteVersion))
						time.sleep(86400)

					except Exception:
						pass


				finally:
					time.sleep(1800)


			self.isCheckingUpdates=False

		if not self.isCheckingUpdates:
			Thread(target=checkUpdates).start()


	def update(self):
		self.isCheckingUpdates=False
		if winVersion=="10" or winVersion=="11":
			downloadUrl="https://blind-center.com.br/downloads/blind_tube/blind_tube.zip"
			zipFilePath="../blind_tube.zip"

		else:
			downloadUrl="https://blind-center.com.br/downloads/blind_tube/blind_tube_w7.zip"
			zipFilePath="../blind_tube_w7.zip"

		self.updateCanceled=False
		if "/s" in self.siteVersion:
			wx.MessageBox("Esta atualização do Blind Tube possui modificações importantes, então não pode ser instalada diretamente pelo programa. Para instalar, selecione a opção fechar todas as instâncias na tela inicial do programa e confirme clicando em sim, depois baixe o programa do site oficial e descompacte novamente.", "Não é possível atualizar ainda", wx.OK|wx.ICON_INFORMATION, self)
			return

		updateDial=wx.Dialog(self, title="Baixando atualização")
		updateProgress=wx.Gauge(updateDial)
		def onUpdatePercentChange(event):
			updateProgress.SetValue(event.percentage)

		updateProgress.Bind(EVT_PERCENT, onUpdatePercentChange)
		cancelUpdate=wx.Button(updateDial, label="&Cancelar")
		def onUpdateCancel(event):
			self.updateCanceled=True
			updateDial.Destroy()

		cancelUpdate.Bind(wx.EVT_BUTTON, onUpdateCancel)
		def onUpdateEvent(event):
			if event.completed==True:
				wx.MessageBox("A atualização foi instalada com sucesso. Clique em ok para reiniciar o programa.", "Instalação concluída", wx.OK|wx.ICON_INFORMATION, self)
				subprocess.Popen("blind_tube.exe")
				updateDial.Destroy()
				window.Destroy()

			else:
				errorType=event.exc.__class__.__name__
				errorDesc=str(event.exc)
				wantToTryAgain=				wx.MessageBox(f"A instalação da atualização não foi concluída corretamente. A mensagem de erro foi: {errorType}: {errorDesc}. Deseja tentar novamente?", "Erro de instalação", wx.YES_NO|wx.ICON_ERROR, self)
				if wantToTryAgain==wx.YES:
					self.update()

				updateDial.Destroy()


		updateDial.Bind(EVT_UPDATE, onUpdateEvent)
		def updateBackground():
			updateStream=requests.get(downloadUrl, stream=True)
			updateSize=int(updateStream.headers.get("content-length"))
			updateFile=open(zipFilePath, "wb")
			currentPercentage=-1
			oldPercentage=currentPercentage
			for part in updateStream.iter_content(chunk_size=4096):
				updateFile.write(part)
				currentFileSize=os.path.getsize(zipFilePath)
				currentPercentage=currentFileSize*100//updateSize
				if not self.updateCanceled:
					if currentPercentage!=oldPercentage:
						wx.PostEvent(updateProgress, PercentEvent(percentage=currentPercentage))

					oldPercentage=currentPercentage

				else:
					sys.exit()


			updateFile.close()
			speak("Instalando atualização", interrupt=True)
			updateDial.SetTitle("Instalando atualização")
			try:
				zipFile=ZipFile(zipFilePath, "r")
				fileNames=zipFile.namelist()
				for fileName in fileNames:
					nameWithoutParent=fileName.replace("blind_tube/", "")
					if os.path.isfile(nameWithoutParent) and not nameWithoutParent.endswith(".dll") and not nameWithoutParent.endswith(".pyd") or "_blind_tube" in nameWithoutParent:
						os.rename(nameWithoutParent, nameWithoutParent+".tmp")

					if not nameWithoutParent.endswith(".dll") and not nameWithoutParent.endswith(".pyd"):
						zipFile.extract(fileName, "../")

					elif not os.path.isfile(nameWithoutParent) or "_blind_tube" in nameWithoutParent:
						zipFile.extract(fileName, "../")



			except Exception as exc:
				wx.PostEvent(updateDial, UpdateEvent(completed=False, exc=exc))

			else:
				zipFile.close()
				os.remove(zipFilePath)
				wx.PostEvent(updateDial, UpdateEvent(completed=True))


		DmThread(target=updateBackground).start()
		updateDial.ShowModal()

	def removeOldVersionFiles(self):
		tempFiles=glob("**/*.tmp", recursive=True)
		if tempFiles:
			processName="blind_tube.exe"
			currentProcessPid=os.getpid()
			for process in psutil.process_iter():
				if process.name()==processName:
					if not process.pid==currentProcessPid:
						process.terminate()



			for tempFile in tempFiles:
				try:
					os.remove(tempFile)

				except Exception as e:
					pass




	def onNewWindow(self):
		def openInstance(event):
			instanceData={
				"mainSubs": self.mainSubs,
				"allSubs": self.allSubs,
				"conf": self.conf,
			}
			newWindow=MainWindow(None, "Blind Tube", instanceData=instanceData)
			newWindow.Show()
			speak("Nova instância do Blind Tube carregada. Caso não esteja selecionada, você pode encontrá-la mantendo pressionada a tecla alt e depois pressionando tab múltiplas vezes.")

		self.Bind(EVT_INSTANCE, openInstance)
		wx.PostEvent(self, InstanceEvent())

	def onNotifClicked(self, videoData):
		speak("Carregando vídeo...")
		videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoData["id"]).execute()
		video=videos["items"][0]
		completeVideoData=getVideoData(video)
		self.playVideo(self, completeVideoData)

	def onNotifSelected(self):
		def loadNotifVideo(event):
			if not self.notifiedVideo:
				speak("Você ainda não recebeu nenhuma notificação de vídeo.")
				return

			speak("Carregando vídeo...")
			videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=self.notifiedVideo).execute()
			video=videos["items"][0]
			videoData=getVideoData(video)
			self.playVideo(self, videoData)

		self.Bind(EVT_NOTIF_SELECT, loadNotifVideo)
		wx.PostEvent(self, NotifSelectedEvent())

	def createHotkey(self):
		hotkeys={}
		if self.getSetting("instance_shortcut"):
			hotkeys["<ctrl>+<shift>+b"]=self.onNewWindow

		if self.getSettingOrigin("notif_method")=="sound" and self.getSetting("notif_shortcut"):
			hotkeys["<ctrl>+<shift>+n"]=self.onNotifSelected

		self.hotkeyChecker=keyboard.GlobalHotKeys(hotkeys)

	def getSetting(self, settingName, category="general"):
		settingValue=self.getSettingOrigin(settingName, category)
		return True if settingValue=="on" else False

	def getSettingOrigin(self, settingName, category="general"):
		if settingName in self.conf[category]:
			settingValue=self.conf[category][settingName]

		else:
			settingValue=self.defaultConf[category][settingName]

		return settingValue

	def getChannelSetting(self, settingName, channelId):
		settingValue=self.getChannelSettingOrigin(settingName, channelId)
		return True if settingValue=="on" else False

	def getChannelSettingOrigin(self, settingName, channelId):
		if self.conf.has_section(channelId):
			settingValue=self.conf[channelId][settingName]

		else:
			settingValue=self.defaultChannelConf[settingName]

		return settingValue

	def setSetting(self, settingName, boolValue, category="general"):
		stringValue="on" if boolValue==True else "off"
		self.conf[category][settingName]=stringValue

	def setSettingOrigin(self, settingName, settingValue, category="general"):
		self.conf[category][settingName]=settingValue

	def setChannelSetting(self, settingName, boolValue, channelId):
		stringValue="on" if boolValue==True else "off"
		self.setChannelSettingOrigin(settingName, stringValue, channelId)

	def setChannelSettingOrigin(self, settingName, settingValue, channelId):
		self.conf[channelId][settingName]=settingValue

	def playVideo(self, currentWindow, videoData, videosData=None, isPlaylist=False, isAuto=False, playlistData=None, playlistItems=None, oldWindow=None, oldStream=None):
		self.shouldPlayNext=True
		ytdl=YoutubeDL({
			"quiet": True,
			"format": "mp4",
		})
		info=ytdl.extract_info(videoData["url"], download=False)
		streamUrl=info["url"]
		videoStream=VideoStream(streamUrl, decode=True)
		videoStream.sliderString="O vídeo está carregando..."
		rattingResponse=yt.videos().getRating(id=videoData["id"]).execute()
		videoData["userRating"]=rattingResponse["items"][0]["rating"]
		channels=yt.channels().list(part="id,snippet,statistics", id=videoData["channelId"]).execute()
		channel=channels["items"][0]
		channelData=getChannelData(channel)
		def onVideoLoad(event):
			currentWindow=event.currentWindow
			videoData=event.videoData
			videosData=event.videosData
			isPlaylist=event.isPlaylist
			isAuto=event.isAuto
			playlistData=event.playlistData
			playlistItems=event.playlistItems
			oldWindow=event.oldWindow
			oldStream=event.oldStream
			if isPlaylist:
				videoPosOnPlaylist=videosData.index(videoData)

			else:
				videoPosOnPlaylist=None

			durationStr=videoData["durationString"]
			videoStream=event.videoStream
			channelData=event.channelData
			windowTitle=videoData["videoTitle"]+" - Blind Tube"
			videoEnded=False

			playerDial=Dialog(currentWindow, title=windowTitle)
			playerDial.Bind(wx.EVT_CHAR_HOOK, lambda event: onVideoChar(event, videoData))
			def onPlayerKeys(event):
				keyCode=event.GetKeyCode()
				if not wx.GetKeyState(wx.WXK_CONTROL):
					if keyCode==wx.WXK_LEFT:
						if not focused(TextCtrl, playerDial):
							decreasePos(5)

						else:
							event.Skip()


					elif keyCode==wx.WXK_RIGHT:
						if not focused(TextCtrl, playerDial):
							increaseResult=increasePos(5)
							if increaseResult==False:
								speak("Não é possível continuar avançando, pois o vídeo ainda está carregando", interrupt=True)


						else:
							event.Skip()


					elif keyCode==wx.WXK_DOWN:
						if not focused(TextCtrl, playerDial) and not focused(wx.Slider, playerDial):
							currentVolume=videoStream.get_volume()
							newVolume=currentVolume-0.02
							if newVolume>=0:
								videoStream.set_volume(newVolume)
								if newVolume<1.01 and currentVolume>=1.01:
									speak("Você voltou a 100% do volume")
									backOriginVolume.Disable()
									volumeLabel.Enable(True)
									volumeControl.Enable(True)

								volumeControl.SetValue(round(newVolume*100))

							else:
								speak("Você já está com o volume no mínimo")


						else:
							event.Skip()


					elif keyCode==wx.WXK_UP:
						if not focused(TextCtrl, playerDial) and not focused(wx.Slider, playerDial):
							currentVolume=videoStream.get_volume()
							newVolume=currentVolume+0.02
							if newVolume<=10:
								videoStream.set_volume(newVolume)
								if newVolume>=1.01 and currentVolume<1.01:
									speak("Você agora está aumentando o volume para mais de 100%")
									volumeLabel.Disable()
									volumeControl.Disable()
									backOriginVolume.Enable(True)

								volumeControl.SetValue(round(newVolume*100))

							else:
								speak("Você já está com o volume no máximo")


						else:
							event.Skip()


					elif keyCode==wx.WXK_SPACE:
						if not commentBox.HasFocus():
							onPause(event)

						else:
							event.Skip()


					else:
						event.Skip()


				else:
					if keyCode==wx.WXK_LEFT:
						if not focused(TextCtrl, playerDial):
							if isPlaylist:
								onPrev(event)


						else:
							event.Skip()


					elif keyCode==wx.WXK_RIGHT:
						if not focused(TextCtrl, playerDial):
							if isPlaylist:
								onNext(event)


						else:
							event.Skip()


					elif keyCode==wx.WXK_DOWN:
						speedStrings=list(videoSpeeds.keys())
						speedValues=list(videoSpeeds.values())
						currentIndex=speedValues.index(videoStream.tempo)
						prevSpeedIndex=currentIndex-1 if currentIndex>0 else len(speedValues)-1
						newSpeedString=speedStrings[prevSpeedIndex]
						newSpeedValue=speedValues[prevSpeedIndex]
						videoStream.tempo=newSpeedValue
						changeSpeed.SetLabel("V&elocidade do vídeo: "+newSpeedString)
						speak("Velocidade "+newSpeedString)

					elif keyCode==wx.WXK_UP:
						speedStrings=list(videoSpeeds.keys())
						speedValues=list(videoSpeeds.values())
						currentIndex=speedValues.index(videoStream.tempo)
						nextSpeedIndex=currentIndex+1 if len(speedValues)>currentIndex+1 else 0
						newSpeedString=speedStrings[nextSpeedIndex]
						newSpeedValue=speedValues[nextSpeedIndex]
						videoStream.tempo=newSpeedValue
						changeSpeed.SetLabel("V&elocidade do vídeo: "+newSpeedString)
						speak("Velocidade "+newSpeedString)

					elif keyCode==ord("S"):
						speak(videoStream.sliderString)

					elif keyCode==ord("V"):
						if not wx.GetKeyState(wx.WXK_SHIFT):
							volumeNumber=round(videoStream.get_volume()*100)
							speak("Volume "+str(volumeNumber))

						else:
							speedStrings=list(videoSpeeds.keys())
							speedNumbers=list(videoSpeeds.values())
							speedString=speedStrings[speedNumbers.index(videoStream.tempo)]
							speak("Velocidade "+speedString)


					else:
						event.Skip()



			playerDial.Bind(wx.EVT_CHAR_HOOK, onPlayerKeys)
			def onElementKeys(event):
				keyCode=event.GetKeyCode()
				eventObject=event.GetEventObject()
				if wx.GetKeyState(wx.WXK_CONTROL) and keyCode==wx.WXK_SPACE:
					if isinstance(eventObject, wx.CheckBox):
						eventToPost=wx.PyCommandEvent(wx.EVT_TOGGLEBUTTON.typeId())
						wx.PostEvent(eventObject, eventToPost)

					elif isinstance(eventObject, wx.Button):
						eventToPost=wx.PyCommandEvent(wx.EVT_BUTTON.typeId())
						wx.PostEvent(eventObject, eventToPost)

					else:
						event.Skip()


				else:
					event.Skip()


			for playerChild in playerDial.GetChildren():
				playerChild.Bind(wx.EVT_KEY_DOWN, onElementKeys)

			def passTo(bytesFinalPosition, sendEvent=True, timeoutForward=False):
				self.isRepositioning=True
				if bytesFinalPosition>len(videoStream)-1:
					bytesFinalPosition=len(videoStream)-1

				elif bytesFinalPosition<0:
					bytesFinalPosition=0

				if videoStream.is_playing:
					videoStream.pause()
					wasPlaying=True

				else:
					wasPlaying=False

				currentPosition=videoStream.bytes_to_seconds()
				finalPosition=videoStream.bytes_to_seconds(bytesFinalPosition)
				if finalPosition<=currentPosition:
					videoStream.set_position(bytesFinalPosition)
					if sendEvent:
						wx.PostEvent(app, PassEvent())

					if wasPlaying:
						videoStream.play()

					return True

				else:
					currentPosition=videoStream.bytes_to_seconds()
					if timeoutForward:
						forwardTimer=Timer(paused=False)

					else:
						forwardTimer=None

					while currentPosition<finalPosition:
						if not self.isRepositioning:
							break

						currentPosition=videoStream.bytes_to_seconds()
						currentPosition+=5
						if currentPosition>finalPosition:
							currentPosition=finalPosition

						bytesPosition=videoStream.seconds_to_bytes(currentPosition)
						while True:
							if not self.isRepositioning:
								break

							if forwardTimer and forwardTimer.elapsed>=8000:
								if wasPlaying:
									videoStream.play()

								return False

							try:
								videoStream.set_position(bytesPosition)

							except Exception:
								time.sleep(0.01)

							else:
								break


						time.sleep(0.01)

					else:
						if sendEvent:
							wx.PostEvent(app, PassEvent())

						if wasPlaying:
							videoStream.play()

						return True



			def setSliderPos():
				if not videoStream.isLoaded:
					return

				pos=int(videoStream.bytes_to_seconds())
				length=int(videoStream.length_in_seconds())
				posStr=durationToString(pos)
				lengthStr=durationToString(length)
				videoStream.sliderString=posStr+" de "+lengthStr

			def loadPrevVideo():
				if videoPosOnPlaylist>0:
					newVideoData=videosData[videoPosOnPlaylist-1]
					DmThread(target=window.playVideo, args=(currentWindow, newVideoData, videosData, True, True, playlistData, playlistItems, playerDial, videoStream)).start()
					return True

				return False


			def loadNextVideo():
				def loadMoreVideos():
					nextPageToken=playlistItems["nextPageToken"]
					newPlaylistItems=yt.playlistItems().list(part="snippet,status", playlistId=playlistData["id"], maxResults=25, pageToken=nextPageToken).execute()
					videoIds=[]
					for playlistItem in newPlaylistItems.get("items", []):
						videoIds.append(playlistItem["snippet"]["resourceId"]["videoId"])

					videoIdsStr=joinIds(videoIds)
					newVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoIdsStr).execute()
					newVideosData=[]
					for video in newVideos.get("items", []):
						videoData=getVideoData(video)
						newVideosData.append(videoData)

					videosData.extend(newVideosData)
					newVideoData=videosData[videoPosOnPlaylist+1]
					wx.PostEvent(currentWindow, NewVideosEvent(videosData=newVideosData, playlistItems=newPlaylistItems))
					DmThread(target=window.playVideo, args=(currentWindow, newVideoData, videosData, True, True, playlistData, playlistItems, playerDial, videoStream)).start()

				if videoPosOnPlaylist<len(videosData)-1:
					newVideoData=videosData[videoPosOnPlaylist+1]
					DmThread(target=window.playVideo, args=(currentWindow, newVideoData, videosData, True, True, playlistData, playlistItems, playerDial, videoStream)).start()
					return True

				else:
					if "nextPageToken" in playlistItems:
						DmThread(target=loadMoreVideos).start()
						return True

					return False


			def decreasePos(sec):
				currentPosition=videoStream.bytes_to_seconds()
				newPosition=currentPosition-sec if currentPosition>=sec else 0
				newPositionBytes=videoStream.seconds_to_bytes(newPosition)
				passResult=passTo(newPositionBytes, sendEvent=False)
				if passResult==True:
					return True

				return False

			def increasePos(sec):
				if videoStream.is_stalled:
					speak("Aguarde o carregamento do vídeo para continuar avançando.")
					return

				currentPosition=videoStream.bytes_to_seconds()
				length=videoStream.length_in_seconds()
				timeLeft=length-currentPosition
				newPosition=currentPosition+sec if timeLeft>=sec else length
				newPositionBytes=videoStream.seconds_to_bytes(newPosition)
				passResult=passTo(newPositionBytes, sendEvent=False, timeoutForward=True)
				if passResult==True:
					return True

				return False

			posLabel=wx.StaticText(playerDial, label="Po&sição do vídeo")
			maxPosition=int(videoStream.length_in_seconds()*1000)
			posSlider=wx.Slider(playerDial, maxValue=maxPosition, value=0)
			posSlider.SetAccessible(AccessibleSlider(videoStream))
			def onSlideDown(event):
				increaseResult=increasePos(5)
				if increaseResult==False:
					speak("Não é possível continuar avançando, pois o vídeo ainda está carregando")

				setSliderPos()

			posSlider.Bind(wx.EVT_SCROLL_LINEDOWN, onSlideDown)
			def onSlideUp(event):
				decreasePos(5)
				setSliderPos()

			posSlider.Bind(wx.EVT_SCROLL_LINEUP, onSlideUp)
			def onSlidePagedown(event):
				increaseResult=increasePos(60)
				if increaseResult==False:
					speak("Não é possível continuar avançando, pois o vídeo ainda está carregando")

				setSliderPos()

			posSlider.Bind(wx.EVT_SCROLL_PAGEDOWN, onSlidePagedown)
			def onSlidePageup(event):
				decreasePos(60)
				setSliderPos()

			posSlider.Bind(wx.EVT_SCROLL_PAGEUP, onSlidePageup)
			def onSlideHome(event):
				videoStream.set_position(0)
				speak("Voltou ao início do vídeo")
				setSliderPos()

			posSlider.Bind(wx.EVT_SCROLL_TOP, onSlideHome)
			def onSlideEnd(event):
				videoLength=videoStream.length_in_seconds()
				endPosition=videoStream.seconds_to_bytes(videoLength)
				passResult=passTo(endPosition, sendEvent=False, timeoutForward=True)
				if passResult==False:
					speak("Não é possível continuar avançando, pois o vídeo ainda está carregando")

				setSliderPos()

			posSlider.Bind(wx.EVT_SCROLL_BOTTOM, onSlideEnd)
			backButton=wx.Button(playerDial, label="&Voltar 10 segundos")
			def onBack(event):
				decreaseResult=decreasePos(10)

			backButton.Bind(wx.EVT_BUTTON, onBack)
			prevButton=wx.Button(playerDial, label="Vídeo an&terior")
			if not isPlaylist:
				prevButton.Disable()

			def onPrev(event):
				if loadPrevVideo()==True:
					speak("Carregando vídeo anterior...")

				else:
					speak("Você já está no primeiro vídeo da playlist")

			prevButton.Bind(wx.EVT_BUTTON, onPrev)
			pauseButton=wx.Button(playerDial, label="&Pausar")
			def onPause(event):
				nonlocal videoEnded
				if videoStream.is_playing:
					videoStream.pause()
					pauseButton.SetLabel("Re&produzir")

				else:
					videoStream.play()
					pauseButton.SetLabel("&Pausar")
					videoEnded=False

			pauseButton.Bind(wx.EVT_BUTTON, onPause)
			pauseButton.SetFocus()
			forwardButton=wx.Button(playerDial, label="&Avançar 10 segundos")
			def onForward(event):
				increaseResult=increasePos(10)
				if increaseResult==False:
					speak("Não é possível continuar avançando, pois o vídeo ainda está carregando", interrupt=True)


			forwardButton.Bind(wx.EVT_BUTTON, onForward)
			nextButton=wx.Button(playerDial, label="Pró&ximo vídeo")
			if not isPlaylist:
				nextButton.Disable()

			def onNext(event):
				if loadNextVideo()==True:
					speak("Carregando próximo vídeo...")

				else:
					speak("Você já está no último vídeo da playlist")


			nextButton.Bind(wx.EVT_BUTTON, onNext)
			cancelAutoplay=wx.Button(playerDial, label="Cancelar reprodução automática")
			cancelAutoplay.Disable()
			def onAutoplayCancel(event):
				self.shouldPlayNext=False
				speak("Reprodução automática cancelada")
				cancelAutoplay.Disable()

			cancelAutoplay.Bind(wx.EVT_BUTTON, onAutoplayCancel)
			volumeLabel=wx.StaticText(playerDial, label="Vo&lume")
			volumeControl=wx.Slider(playerDial, value=100)
			def onVolumeChange(event):
				newVolume=event.GetInt()
				videoStream.set_volume(newVolume/100)


			volumeControl.Bind(wx.EVT_SLIDER, onVolumeChange)
			backOriginVolume=wx.Button(playerDial, label="Voltar ao vo&lume original")
			backOriginVolume.Disable()
			def onBackOriginVolume(event):
				videoStream.set_volume(1)
				speak("Voltou ao volume original")
				volumeLabel.Enable(True)
				volumeControl.Enable(True)
				backOriginVolume.Disable()

			backOriginVolume.Bind(wx.EVT_BUTTON, onBackOriginVolume)
			customVolume=LinkButton(playerDial, mainLabel="Definir volume personalizad&o...", note="Limite: 1000")
			def onCustomVolume(event):
				def onVolumeConfirm(event):
					volumeString=volumeBox.GetValue()
					if not volumeString.isdigit():
						wx.MessageBox("O conteúdo que você digitou não é um número", "Volume inválido", wx.OK|wx.ICON_ERROR, volumeDial)
						volumeBox.Clear()
						return

					newVolume=int(volumeString)
					if newVolume>1000 or newVolume<0:
						wx.MessageBox("O volume que você informou é inválido. Certifique-se de que o valor digitado é maior que 0, e menor ou igual a 1000.", "Volume inválido", wx.OK|wx.ICON_ERROR, volumeDial)
						volumeBox.Clear()
						return

					videoStream.set_volume(newVolume/100)
					volumeLabel.Disable()
					volumeControl.Disable()
					backOriginVolume.Enable(True)
					volumeDial.Destroy()

				volumeDial=Dialog(playerDial, title="Definir volume personalizado", closePrev=False)
				volumeBoxLabel=wx.StaticText(volumeDial, label="&Volume personalizado (até 1000)")
				volumeBox=TextCtrl(volumeDial, style=wx.TE_PROCESS_ENTER|wx.TE_DONTWRAP)
				volumeBox.Bind(wx.EVT_TEXT_ENTER, onVolumeConfirm)
				confirmVolume=wx.Button(volumeDial, label="&Alterar")
				confirmVolume.Bind(wx.EVT_BUTTON, onVolumeConfirm)
				cancelVolume=wx.Button(volumeDial, wx.ID_CANCEL, "&Cancelar")
				def onVolumeCancel(event):
					volumeDial.Destroy()

				cancelVolume.Bind(wx.EVT_BUTTON, onVolumeCancel)
				volumeDial.Show()

			customVolume.Bind(wx.EVT_BUTTON, onCustomVolume)
			changeSpeed=LinkButton(playerDial, mainLabel="Velocidad&e do vídeo: 1x")
			def onSpeedChange(event):
				speedMenu=wx.Menu()
				for index, speed in enumerate(videoSpeeds.keys()):
					speedMenu.Append(index+1, speed)
					def onSpeedSelected(event):
						itemId=event.GetId()
						menuItem=speedMenu.FindItemById(itemId)
						speedValues=list(videoSpeeds.values())
						newSpeed=speedValues[itemId-1]
						videoStream.tempo=newSpeed
						itemLabel=menuItem.GetItemLabelText()
						changeSpeed.SetLabel("Velocidad&e do vídeo: "+itemLabel)

					speedMenu.Bind(wx.EVT_MENU, onSpeedSelected)

				playerDial.PopupMenu(speedMenu)

			changeSpeed.Bind(wx.EVT_BUTTON, onSpeedChange)
			goToPosition=LinkButton(playerDial, mainLabel="I&r para a posição...")
			def onGoToPosition(event):
				def onPassConfirm(event):
					posExp="(0?(?!:)[0-9]+:0?(?!:)[0-9]+:0?[0-9]+|0?(?!:)[0-9]+:0?(?!:)[0-9]+)"
					tipedPos=posBox.GetValue()
					posIsValid=re.fullmatch(posExp, tipedPos)
					if not posIsValid:
						wx.MessageBox("A posição que você forneceu não é válida.", "Posição inválida", wx.OK|wx.ICON_ERROR, passDial)
						posBox.Clear()
						return

					totalSeconds=posToSeconds(tipedPos)
					if totalSeconds>videoStream.length_in_seconds():
						wx.MessageBox("A posição que você forneceu é maior que a duração total do vídeo. Verifique a duração e tente novamente.", "Posição inválida", wx.OK|wx.ICON_ERROR, passDial)
						posBox.Clear()
						return

					newBytesPosition=videoStream.seconds_to_bytes(totalSeconds)
					oldPosition=videoStream.get_position()
					passingDial=wx.Dialog(passDial, title="Passando até "+tipedPos+"...")
					cancelPass=wx.Button(passingDial, label="&Cancelar")
					def onPassCancel(event):
						self.isRepositioning=False
						passingDial.Destroy()
						passDial.Destroy()
						videoStream.set_position(oldPosition)
						videoStream.play()

					cancelPass.Bind(wx.EVT_BUTTON, onPassCancel)
					def onPassComplete(event):
						self.isRepositioning=False
						videoStream.play()
						passingDial.Destroy()
						passDial.Destroy()

					app.Bind(EVT_PASS, onPassComplete)

					DmThread(target=passTo, args=(newBytesPosition,)).start()
					passingDial.Show()

				passDial=wx.Dialog(playerDial, title="Ir para a posição")
				posLabel=wx.StaticText(passDial, label="Informe a &posição desejada, no formato hora dois pontos minuto dois pontos segundo (ou apenas minuto dois pontos segundo)")
				posBox=TextCtrl(passDial, style=wx.TE_PROCESS_ENTER|wx.TE_DONTWRAP)
				posBox.Bind(wx.EVT_TEXT_ENTER, onPassConfirm)
				confirmPos=wx.Button(passDial, wx.ID_OK, "&Alterar")
				confirmPos.Bind(wx.EVT_BUTTON, onPassConfirm)
				cancelPos=wx.Button(passDial, wx.ID_CANCEL, label="&Cancelar")
				def onPosCancel(event):
					passDial.Destroy()

				cancelPos.Bind(wx.EVT_BUTTON, onPosCancel)
				passDial.Show()

			goToPosition.Bind(wx.EVT_BUTTON, onGoToPosition)
			def onCharPressed(event):
				keyCode=event.GetKeyCode()
				if keyCode==wx.WXK_ESCAPE:
					onPlayerClose(event)

				else:
					event.Skip()


			playerDial.Bind(wx.EVT_CHAR_HOOK, onCharPressed)
			transcriptButton = LinkButton(playerDial, mainLabel="Mostrar &transcrição do vídeo", note="Abre na mesma janela", isMenu=False)
			transcriptLabel = wx.StaticText(playerDial, label="&Transcrição do vídeo")
			transcriptLabel.Disable()
			transcriptBox = TextCtrl(playerDial, style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_DONTWRAP)
			transcriptBox.Disable()
			def onTranscript(event):
				def getTranscript():
					try:
						transcript = YouTubeTranscriptApi.get_transcript(videoData["id"], languages=[self.currentLanguageCode])
						self.transcript = transcript

					except Exception as e:
						languageName = list(languageDict.keys())[list(languageDict.values()).index(self.currentLanguageCode)]
						wantTranslate = wx.MessageBox(f"Não foi possível encontrar uma transcrição em {languageName} para o vídeo. Deseja tentar traduzir a transcrição original para o idioma definido?", "Traduzir transcrição", wx.YES_NO|wx.ICON_QUESTION, playerDial)
						if wantTranslate == wx.YES:
							try:
								transcriptList = YouTubeTranscriptApi.list_transcripts(videoData["id"])
								for originTranscript in transcriptList:
									if originTranscript.is_translatable:
										transcript = originTranscript.translate(self.currentLanguageCode)
										self.transcript = transcript.fetch()
										break



							except Exception as e:
								wx.MessageBox("Não foi possível traduzir a transcrição. Caso queira obter a transcrição no idioma original, altere o idioma da transcrição pressionando as teclas alt+ç no player de vídeo.", "Erro ao traduzir", wx.OK|wx.ICON_ERROR, playerDial)
								return


						else:
							return


					transcriptLabel.Enable(True)
					transcriptBox.Enable(True)
					for index, transcriptFragment in enumerate(self.transcript):
						transcriptBox.AppendText(transcriptFragment["text"])
						if index < len(self.transcript) - 1:
							transcriptBox.AppendText("\r\n")


					transcriptBox.SetInsertionPoint(0)
					transcriptBox.SetFocus()
					speak("Transcrição carregada. Você pode acessá-la pressionando alt+t.", interrupt=True)
					transcriptButton.Disable()
					#changeTranscript.Disable()

				DmThread(target=getTranscript).start()

			transcriptButton.Bind(wx.EVT_BUTTON, onTranscript)
			changeTranscript = LinkButton(playerDial, mainLabel="Idioma para buscar a transcri&ção: Português")
			def onTranscriptChange(event):
				languageMenu = wx.Menu()
				for index, language in enumerate(languageList):
					languageMenu.Append(index + 1, language)

				def onLanguageSelected(event):
					itemId = event.GetId()
					menuItem = languageMenu.FindItemById(itemId)
					itemLabel = menuItem.GetItemLabelText()
					self.currentLanguageCode = languageDict[itemLabel]
					changeTranscript.SetLabel("Idioma para buscar a transcri&ção: " + itemLabel)

				languageMenu.Bind(wx.EVT_MENU, onLanguageSelected)
				playerDial.PopupMenu(languageMenu)

			changeTranscript.Bind(wx.EVT_BUTTON, onTranscriptChange)
			infoLabel=wx.StaticText(playerDial, label="In&formações")
			infoBox=TextCtrl(playerDial, style=wx.TE_READONLY|wx.TE_MULTILINE|wx.TE_DONTWRAP)
			if videoData["viewCount"]!="1":
				infoBox.AppendText(f"{videoData['viewCount']} visualizações")

			else:
				infoBox.AppendText(f"{videoData['viewCount']} visualização")

			infoBox.AppendText("\n"+durationStr)
			publishedAt=videoData["publishedAt"]
			publishedAtString=dateToString(publishedAt)
			infoBox.AppendText("\nPublicado em "+publishedAtString)
			if channelData["subscriberCount"]!="1":
				infoBox.AppendText(f"\nPor {channelData['channelTitle']}, {channelData['subscriberCount']} inscritos.")

			else:
				infoBox.AppendText(f"\nPor {channelData['channelTitle']}, {channelData['subscriberCount']} inscrito.")

			infoBox.AppendText(f"\n{videoData['likeCount']} marcações gostei")
			infoBox.SetInsertionPoint(0)
			descriptionLabel=wx.StaticText(playerDial, label="&Descrição do vídeo")
			descriptionBox=TextCtrl(playerDial, style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_DONTWRAP, value=videoData["description"])
			downloadButton=LinkButton(playerDial, mainLabel="&Baixar vídeo")
			downloadButton.Bind(wx.EVT_BUTTON, lambda event: onDownload(event, videoData["videoTitle"], videoData["id"], playerDial))
			if videoData["likeCount"]:
				if videoData["userRating"]=="like":
					likeButton=wx.ToggleButton(playerDial, label=f"Remover &gostei ({videoData['likeString']} marcações)")
					likeButton.SetValue(True)

				else:
					likeButton=wx.ToggleButton(playerDial, label=f"Marcar como &gostei ({videoData['likeString']} marcações)")


			else:
				likeButton=LinkButton(playerDial, mainLabel="As marcações &gostei para este vídeo estão desativadas: saiba mais")

			def onVideoLike(event):
				if not videoData["likeCount"]:
					wx.MessageBox("Você não pode marcar este vídeo como gostei porque as avaliações dele estão desativadas. Provavelmente, isso foi feito intensionalmente pelo dono do canal que postou este vídeo.", "Avaliações desativadas", parent=playerDial)
					return

				if likeButton.GetValue()==True:
					response=yt.videos().rate(id=videoData["id"], rating="like").execute()
					self.playSound("like")
					speak("Alerta adicionado aos vídeos marcados com gostei.")
					videoData["likeCount"]=str(int(videoData["likeCount"])+1)
					likeButton.SetLabel(f"Remover &gostei ({videoData['likeString']} marcações)")
					if videoData["userRating"]=="dislike":
						dislikeButton.SetLabel("Marcar como &não gostei")
						dislikeButton.SetValue(False)

					videoData["userRating"]="like"

				else:
					response=yt.videos().rate(id=videoData["id"], rating="none").execute()
					speak("Alerta removido dos vídeos marcados com gostei.")
					videoData["likeCount"]=str(int(videoData["likeCount"])-1)
					likeButton.SetLabel(f"Marcar como &gostei novamente ({videoData['likeString']} marcações)")
					videoData["userRating"]="none"

			if videoData["likeCount"]:
				likeButton.Bind(wx.EVT_TOGGLEBUTTON, onVideoLike)

			else:
				likeButton.Bind(wx.EVT_BUTTON, onVideoLike)

			if videoData["likeCount"]:
				if videoData["userRating"]=="dislike":
					dislikeButton=wx.ToggleButton(playerDial, label="Remover &não gostei")
					dislikeButton.SetValue(True)

				else:
					dislikeButton=wx.ToggleButton(playerDial, label="Marcar como &não gostei")

			else:
				dislikeButton=LinkButton(playerDial, mainLabel="As marcações &não gostei para este vídeo estão desativadas: saiba mais")

			def onVideoDislike(event):
				if not videoData["likeCount"]:
					wx.MessageBox("Você não pode marcar este vídeo como não gostei porque as avaliações dele estão desativadas. Provavelmente, isso foi feito intensionalmente pelo dono do canal que postou este vídeo.", "Avaliações desativadas", parent=playerDial)
					return

				if dislikeButton.GetValue()==True:
					response=yt.videos().rate(id=videoData["id"], rating="dislike").execute()
					self.playSound("dislike")
					speak("Alerta você marcou este vídeo como não gostei")
					dislikeButton.SetLabel("Remover &não gostei")
					if videoData["userRating"]=="like":
						videoData["likeCount"]=str(int(videoData["likeCount"])-1)
						videoData["likeString"]=likesToString(videoData["likeCount"])
						likeButton.SetLabel(f"Marcar como &gostei ({videoData['likeString']} marcações)")
						likeButton.SetValue(False)

					videoData["userRating"]="dislike"

				else:
					response=yt.videos().rate(id=videoData["id"], rating="none").execute()
					speak("Alerta você removeu seu não gostei deste vídeo.")
					dislikeButton.SetLabel("Marcar como &não gostei")
					videoData["userRating"]="none"


			if videoData["likeCount"]:
				dislikeButton.Bind(wx.EVT_TOGGLEBUTTON, onVideoDislike)

			else:
				dislikeButton.Bind(wx.EVT_BUTTON, onVideoDislike)

			if videoData["commentCount"]:
				commentsButton=LinkButton(playerDial, mainLabel=f"&Comentários ({videoData['commentCount']})")
			else:
				commentsButton=LinkButton(playerDial, mainLabel="Os &comentários estão desativados. Saiba mais")
			def onCommentsOpen(event):
				if not videoData["commentCount"]:
					wx.MessageBox("Não é possível acessar a lista de comentários porque eles estão desativados.\nIsso pode ocorrer devido à vários motivos, como o proprietário do canal tê-los desativado ou o vídeo ser destinado a crianças.", "Comentários desativados", parent=playerDial)
					return

				elif videoData["commentCount"]==0:
					wx.MessageBox("Não há nenhum comentário para exibir nesta lista. Se você deseja adicionar um novo comentário, vá ao campo de edição disponível após o botão de comentários.", "Nenhum comentário", parent=playerDial)
					return

				speak("Carregando comentários...")
				def loadComments():
					commentThreads=yt.commentThreads().list(part="id,snippet,replies", videoId=videoData["id"], maxResults=50, textFormat="plainText", order="relevance").execute()
					playerDial.Bind(EVT_LOAD, onCommentsLoaded)
					wx.PostEvent(playerDial, LoadEvent(commentThreads=commentThreads))

				DmThread(target=loadComments).start()
				def onCommentsLoaded(event):
					def addComment(list, commentData):
						if self.getSetting("delete_at"):
							authorName=fixHandles(commentData["authorName"])

						else:
							authorName=commentData["authorName"]

						text=commentData["text"]
						text=text.replace("​", "")
						commentString=f"{authorName}; {getDatesDiferense(commentData['publishedAt'])}; {text}; {commentData['likeString']} marcações gostei; {commentData['replyCount']} respostas"
						list.Append((commentString,))

					def addReply(list, replyData):
						if self.getSetting("delete_at"):
							authorName=fixHandles(replyData["authorName"])
							text=fixHandles(replyData["text"], isReply=True)

						else:
							authorName=replyData["authorName"]
							text=replyData["text"]

						text=text.replace("​", "")
						replyString=f"{authorName}; {getDatesDiferense(replyData['publishedAt'])}; {text}; {replyData['likeString']} marcações gostei"
						list.Append((replyString,))

					def translateComment(text):
						try:
							translatedObj=translator.translate(text, dest="pt")

						except Exception:
							speak("Não foi possível traduzir o comentário")

						else:
							speak(translatedObj.text)


					def translateReply(text):
						try:
							translatedObj=translator.translate(text, dest="pt")

						except Exception:
							speak("Não foi possível traduzir a resposta")

						else:
							speak(translatedObj.text)


					sortMethod="relevance"
					commentsWindow=wx.Frame(self, title=f"Comentários do vídeo ({videoData['commentCount']})")
					commentsPanel=wx.Panel(commentsWindow)
					commentsClose=wx.Button(commentsPanel, wx.ID_CANCEL, "fechar")
					def onCommentsClose(event):
						commentsWindow.Destroy()

					commentsClose.Bind(wx.EVT_BUTTON, onCommentsClose)
					commentsLabel=wx.StaticText(commentsPanel, label="&Comentários")
					commentsList=List(commentsPanel, title="Comentários")
					commentsList.SetFocus()
					commentsData=[]
					commentThreads=event.commentThreads
					for commentThread in commentThreads.get("items", []):
						comment=commentThread["snippet"]["topLevelComment"]
						commentData=getCommentData(comment, commentThread, videoData)
						commentsData.append(commentData)
						addComment(commentsList, commentData)

					completeTextLabel=wx.StaticText(commentsPanel, label="&Texto completo")
					completeText=TextCtrl(commentsPanel, style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_DONTWRAP, value="Nenhum comentário selecionado ainda.")
					goToChannel=LinkButton(commentsPanel, mainLabel="Ir ao canal do a&utor", isMenu=False)
					goToChannel.Disable()
					def onGoToChannel(event):
						speak("Carregando canal do autor...")
						DmThread(target=loadChannel, args=(commentData["authorId"], commentsWindow)).start()

					goToChannel.Bind(wx.EVT_BUTTON, onGoToChannel)
					replyLabel=wx.StaticText(commentsPanel, label="R&esponder")
					replyLabel.Disable()
					replyBox=TextCtrl(commentsPanel, style=wx.TE_MULTILINE|wx.TE_DONTWRAP)
					replyBox.Disable()
					def onReply(event):
						replyBox=event.GetEventObject()
						if replyBox.IsEmpty():
							speak("Para responder a um comentário, o campo de resposta não deve estar vazio.")
							return

						def sendReply():
							replyText=replyBox.GetValue()
							sentReply=yt.comments().insert(
							part="snippet",
							body={
									"snippet": {
											"parentId": commentData["id"],
											"textOriginal": replyText
									}
							}).execute()
							commentsWindow.Bind(EVT_SENT, onReplySent)
							wx.PostEvent(commentsWindow, SendEvent(sentReply=sentReply))

						DmThread(target=sendReply).start()
						def onReplySent(event):
							speak("Resposta enviada.")
							replyBox.SetValue("")


					replyBox.Bind(wx.EVT_TEXT_ENTER, onReply)
					seeReplies=LinkButton(commentsPanel, mainLabel="Nenhum comentário selecionado para ver as respostas")
					seeReplies.Disable()
					seeOwnerReplies=LinkButton(commentsPanel, mainLabel=f"Ver apenas as respostas do dono do canal")
					seeOwnerReplies.Disable()
					def onSeeReplies(event):
						speak("Carregando respostas...")
						buttonClicked=1 if event.GetId()==seeReplies.GetId() else 2
						def loadReplies():
							replies=yt.comments().list(part="snippet", parentId=commentData["id"], maxResults=50, textFormat="plainText").execute()
							repliesData=[]
							for reply in replies.get("items", []):
								replyData=getReplyData(reply, commentData)
								if buttonClicked==1 or replyData["isFromOwner"]:
									repliesData.append(replyData)


							while "nextPageToken" in replies:
								replies=yt.comments().list(part="snippet", parentId=commentData["id"], maxResults=50, pageToken=replies["nextPageToken"], textFormat="plainText").execute()
								for reply in replies.get("items", []):
									replyData=getReplyData(reply, commentData)
									if buttonClicked==1 or replyData["isFromOwner"]:
										repliesData.append(replyData)



							commentsWindow.Bind(EVT_LOAD, onRepliesLoaded)
							wx.PostEvent(commentsWindow, LoadEvent(repliesData=repliesData))

						DmThread(target=loadReplies).start()
						def onRepliesLoaded(event):
							repliesData=event.repliesData
							repliesDial=wx.Dialog(commentsWindow, title="Respostas")
							repliesClose=wx.Button(repliesDial, wx.ID_CANCEL, "Voltar")
							def onRepliesClose(event):
								repliesDial.Destroy()
								commentsList.SetFocus()

							repliesClose.Bind(wx.EVT_BUTTON, onRepliesClose)
							repliesLabel=wx.StaticText(repliesDial, label="&Respostas")
							repliesList=List(repliesDial, title="Respostas")
							repliesList.SetFocus()
							for replyData in repliesData:
								addReply(repliesList, replyData)

							completeTextLabel=wx.StaticText(repliesDial, label="&Texto completo")
							completeText=TextCtrl(repliesDial, style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_DONTWRAP, value="Nenhuma resposta selecionada ainda.")
							goToChannel=LinkButton(repliesDial, mainLabel="Ir ao canal do a&utor", isMenu=False)
							goToChannel.Disable()
							def onGoToChannel(event):
								speak("Carregando canal do autor...")
								DmThread(target=loadChannel, args=(replyData["authorId"], repliesDial)).start()

							goToChannel.Bind(wx.EVT_BUTTON, onGoToChannel)
							replyLabel=wx.StaticText(repliesDial, label="R&esponder")
							replyBox=TextCtrl(repliesDial, style=wx.TE_MULTILINE|wx.TE_DONTWRAP)
							replyBox.Bind(wx.EVT_TEXT_ENTER, onReply)
							def onReplyChange(event):
								nonlocal replyData
								replyData=getDataByIndex(repliesList, repliesData)
								formatedText=formatComment(replyData["originalText"])
								formatedText=formatedText.replace("​", "")
								if self.getSetting("delete_at"):
									formatedText=fixHandles(formatedText, isReply=True)

								completeText.SetValue(formatedText)
								authorId=replyData["authorId"]
								authorName=replyData["authorName"]
								originAuthorName=authorName
								if self.getSetting("delete_at"):
									authorName=fixHandles(authorName)

								goToChannel.SetNote(authorName)
								goToChannel.Enable(True)
								replyBox.SetValue("")
								replyBox.AppendText("@"+originAuthorName+" ")

							repliesList.Bind(wx.EVT_LIST_ITEM_FOCUSED, onReplyChange)
							def onKeyDown(event):
								keyCode=event.GetKeyCode()
								if wx.GetKeyState(wx.WXK_CONTROL):
									if keyCode==ord("L"):
										speak(f"{replyData['likeCount']} marcações gostei")

									elif keyCode==ord("A"):
										if not focused(TextCtrl, repliesDial):
											speak(replyData["authorName"])

										else:
											event.Skip()


									elif keyCode==ord("P"):
										publishedAt=replyData["publishedAt"]
										publishedAtString=dateToString(publishedAt)
										speak(f"Publicado em {publishedAtString}")

									elif keyCode==ord("T"):
										if not wx.GetKeyState(wx.WXK_SHIFT):
											speak(completeText.GetValue())

										else:
											DmThread(target=translateReply, args=(completeText.GetValue(),)).start()


									else:
										event.Skip()


								else:
									event.Skip()


							repliesDial.Bind(wx.EVT_CHAR_HOOK, onKeyDown)
							repliesDial.Show()


					seeReplies.Bind(wx.EVT_BUTTON, onSeeReplies)
					seeOwnerReplies.Bind(wx.EVT_BUTTON, onSeeReplies)
					sortBy=LinkButton(commentsPanel, mainLabel="&Ordenar por: mais relevantes")
					def onSort(event):
						sortMenu=wx.Menu()
						relevance=sortMenu.Append(1, "Mais &relevantes")
						time=sortMenu.Append(2, "Mais r&ecentes")
						def sort(sortMethod):
							commentsList.DeleteAllItems()
							commentsData.clear()
							sortedComments={
								"items": []
							}
							commentThreads=yt.commentThreads().list(part="id,snippet,replies", videoId=videoData["id"], maxResults=50, textFormat="plainText", order=sortMethod).execute()
							commentsWindow.Bind(EVT_LOAD, onCommentsSorted)
							wx.PostEvent(commentsWindow, LoadEvent(commentThreads=commentThreads))

						def onCommentsSorted(event):
							nonlocal commentThreads
							commentThreads=event.commentThreads
							for commentThread in commentThreads.get("items", []):
								comment=commentThread["snippet"]["topLevelComment"]
								commentData=getCommentData(comment, commentThread, videoData)
								commentsData.append(commentData)
								addComment(commentsList, commentData)

							speak("Alerta comentários ordenados", interrupt=True)

						def onSortSelected(event):
							nonlocal sortMethod
							itemId=event.GetId()
							menuItem=sortMenu.FindItemById(itemId)
							if itemId==1:
								sortMethod="relevance"

							else:
								sortMethod="time"

							itemLabel=menuItem.GetItemLabelText()
							sortBy.SetLabel("&Ordenar por: "+itemLabel)
							DmThread(target=sort, args=(sortMethod,)).start()

						sortMenu.Bind(wx.EVT_MENU, onSortSelected)
						commentsWindow.PopupMenu(sortMenu)

					sortBy.Bind(wx.EVT_BUTTON, onSort)
					commentsLoadMore=wx.Button(commentsPanel, label="Ca&rregar mais")
					if not "nextPageToken" in commentThreads:
						commentsLoadMore.Disable()

					def onLoadMore(event):
						speak("Carregando mais...")
						def loadMoreComments():
							nextPageToken=commentThreads["nextPageToken"]
							newCommentThreads=yt.commentThreads().list(part="id,snippet,replies", videoId=videoData["id"], maxResults=50, pageToken=nextPageToken, textFormat="plainText", order=sortMethod).execute()
							commentsWindow.Bind(EVT_LOAD, onMoreCommentsLoaded)
							wx.PostEvent(commentsWindow, LoadEvent(newCommentThreads=newCommentThreads))

						DmThread(target=loadMoreComments).start()
						def onMoreCommentsLoaded(event):
							newCommentThreads=event.newCommentThreads
							nonlocal commentThreads
							commentThreads=newCommentThreads
							for commentThread in newCommentThreads.get("items", []):
								comment=commentThread["snippet"]["topLevelComment"]
								commentData=getCommentData(comment, commentThread, videoData)
								commentsData.append(commentData)
								addComment(commentsList, commentData)

							speak("Comentários carregados.")
							if not "nextPageToken" in newCommentThreads:
								speak("Fim dos comentários.")
								commentsList.SetFocus()
								commentsLoadMore.Disable()



					commentsLoadMore.Bind(wx.EVT_BUTTON, onLoadMore)
					commentLabel=wx.StaticText(commentsPanel, label="Adicionar um co&mentário público...")
					commentBox=TextCtrl(commentsPanel, style=wx.TE_MULTILINE|wx.TE_DONTWRAP)
					commentBox.Bind(wx.EVT_TEXT_ENTER, onAddComment)

					def onCommentChange(event):
						nonlocal commentData
						commentData=getDataByIndex(commentsList, commentsData)
						formatedText=formatComment(commentData["originalText"])
						if self.getSetting("delete_at"):
							formatedText=fixHandles(formatedText, replaceNumbers=False)

						formatedText=formatedText.replace("​", "")
						completeText.SetValue(formatedText)
						authorName=fixHandles(commentData["authorName"])
						goToChannel.SetNote(authorName)
						goToChannel.Enable(True)
						if commentData["replyCount"]<500:
							replyLabel.Enable(True)
							replyBox.Enable(True)

						else:
							replyLabel.Enable(False)
							replyBox.Enable(False)

						if commentData["replyCount"]==1:
							seeReplies.SetLabel("&Ver resposta")
							seeReplies.Enable(True)

						elif commentData["replyCount"]>1:
							seeReplies.SetLabel(f"&Ver {commentData['replyCount']} respostas")
							seeReplies.Enable(True)

						else:
							seeReplies.SetLabel("0 respostas")
							seeReplies.Enable(False)

						ownerReplied=commentData["ownerReplied"]
						if ownerReplied:
							seeOwnerReplies.SetLabel(f"Ver a&penas as respostas de {commentData['channelTitle']}")
							seeOwnerReplies.Enable(True)

						else:
							seeOwnerReplies.SetLabel("Não há respostas enviadas pelo dono do canal.")
							seeOwnerReplies.Enable(False)

					commentsList.Bind(wx.EVT_LIST_ITEM_FOCUSED, onCommentChange)
					def onKeyDown(event):
						keyCode=event.GetKeyCode()
						if wx.GetKeyState(wx.WXK_CONTROL):
							if keyCode==ord("L"):
								speak(f"{commentData['likeCount']} marcações gostei")

							elif keyCode==ord("R"):
								if commentData["replyCount"]!=1:
									speak(f"{commentData['replyCount']} respostas")

								else:
									speak(f"{commentData['replyCount']} resposta")


							elif keyCode==ord("A"):
								if not focused(TextCtrl, commentsPanel):
									speak(commentData["authorName"])

								else:
									event.Skip()


							elif keyCode==ord("P"):
								publishedAt=commentData["publishedAt"]
								publishedAtString=dateToString(publishedAt)
								speak(f"Publicado em {publishedAtString}")

							elif keyCode==ord("T"):
								if not wx.GetKeyState(wx.WXK_SHIFT):
									speak(completeText.GetValue())

								else:
									DmThread(target=translateComment, args=(completeText.GetValue(),)).start()


							else:
								event.Skip()


						else:
							if keyCode==wx.WXK_ESCAPE:
								commentsWindow.Destroy()

							else:
								event.Skip()



					commentsWindow.Bind(wx.EVT_CHAR_HOOK, onKeyDown)
					self.playSound("comments")
					commentsWindow.Show()


			commentsButton.Bind(wx.EVT_BUTTON, onCommentsOpen)
			commentLabel=wx.StaticText(playerDial, label="Adicionar um co&mentário público...")
			commentBox=TextCtrl(playerDial, style=wx.TE_MULTILINE|wx.TE_DONTWRAP)
			if not videoData["commentCount"]:
				commentBox.Disable()

			def onAddComment(event):
				commentBox=event.GetEventObject()
				if commentBox.IsEmpty():
					speak("Para enviar um comentário, o campo correspondente não deve estar vazio.")
					return

				def addComment():
					commentText=commentBox.GetValue()
					sentComment=yt.commentThreads().insert(
						part="snippet",
						body={
							"snippet": {
								"videoId": videoData["id"],
								"topLevelComment": {
									"snippet": {
										"textOriginal": commentText
									}
								}
							}
						}).execute()
					commentBox.Bind(EVT_SENT, onCommentSent)
					wx.PostEvent(commentBox, SendEvent(sentComment=sentComment))

				DmThread(target=addComment).start()
				def onCommentSent(event):
					speak("Comentário enviado")
					commentBox.SetValue("")


			commentBox.Bind(wx.EVT_TEXT_ENTER, onAddComment)
			goToChannel=LinkButton(playerDial, mainLabel="Ir ao canal do a&utor", isMenu=False, note=channelData["channelTitle"])
			def onGoToChannel(event):
				speak("Carregando canal do autor...")
				DmThread(target=loadChannel, args=(channelData["id"], playerDial)).start()

			goToChannel.Bind(wx.EVT_BUTTON, onGoToChannel)
			if not channelData["isSubscribed"]:
				subscribe=wx.Button(playerDial, label=f"&Inscreva-se em {channelData['channelTitle']}")

			else:
				subscribe=wx.Button(playerDial, label=f"Cancelar &inscrição de {channelData['channelTitle']}")

			subscribe.Bind(wx.EVT_BUTTON, lambda event: onSubscribe(event, channelData))

			def onPlayerClose(event):
				nonlocal videoEnded
				nonlocal videoStream
				try:
					videoStream.free()

				except Exception as e:
					pass

				videoStream.isLoaded=False
				videoEnded=True
				if isPlaylist:
					self.shouldPlayNext=False

				playerDial.Destroy()
				if not wx.GetKeyState(wx.WXK_ALT):
					currentWindow.Show()
					if isAuto:
						wx.PostEvent(currentWindow, VideoCloseEvent(videoPos=videoPosOnPlaylist))


			closeButton=wx.Button(playerDial, wx.ID_CANCEL, "Fechar vídeo")
			closeButton.Bind(wx.EVT_BUTTON, onPlayerClose)
			playerDial.Bind(wx.EVT_CLOSE, onPlayerClose)
			def checkPlayerState():
				nonlocal videoEnded
				stalledBefore=videoStream.is_stalled and not videoStream.is_playing
				saveInfoTimer=Timer(paused=False)
				while True:
					time.sleep(0.25)
					if not videoStream.isLoaded:
						break

					if videoStream.is_stopped and not videoEnded:
						wx.PostEvent(playerDial, VideoEndEvent())
						videoEnded=True

					stalledNow=videoStream.is_stalled and not videoStream.is_playing
					if not videoStream.isLoaded:
						break

					if stalledNow and not stalledBefore:
						speak("Alerta o vídeo está carregando...", interrupt=True)

					stalledBefore=stalledNow
					if not stalledNow:
						setSliderPos()

					if saveInfoTimer.elapsed>=2000 :
						saveInfoTimer.restart()
						watchedsFile=open("data/watcheds.txt", "r")
						watchedsList=[videoPosition for videoPosition in watchedsFile]
						watchedsFile.close()
						watchedsFile=open("data/watcheds.txt", "w")
						for videoPosition in watchedsList:
							videoPosition=videoPosition.strip()
							videoList=videoPosition.split(":")
							if not videoData["id"]==videoList[0]:
								watchedsFile.write(videoPosition+"\n")


						currentPosition=videoStream.get_position()
						if not videoEnded:
							watchedsFile.write(f"{videoData['id']}:{currentPosition}")

						watchedsFile.close()



			def onVideoEnded(event):
				speak("Fim do vídeo")
				pauseButton.SetLabel("Re&petir vídeo")
				if isPlaylist and self.getSetting("autoplay_on_playlists"):
					if loadNextVideo()==True:
						speak("Carregando próximo vídeo...")
						cancelAutoplay.Enable(True)
						cancelAutoplay.SetFocus()

					else:
						speak("Fim da playlist")



			playerDial.Bind(EVT_VIDEO_END, onVideoEnded)
			channelId=channelData["id"]
			speedString=self.getChannelSettingOrigin("default_speed", channelId)
			if speedString=="default":
				speedString=self.getSettingOrigin("default_speed")

			videoSpeed=videoSpeeds[speedString]
			videoStream.tempo=videoSpeed
			changeSpeed.SetLabel("Velocidad&e do vídeo: "+speedString)
			languageString = self.getChannelSettingOrigin("default_transcript_language", channelId)
			if languageString == "default":
				languageString = self.getSettingOrigin("default_transcript_language")

			self.currentLanguageCode = languageString
			languageName = list(languageDict.keys())[list(languageDict.values()).index(self.currentLanguageCode)]
			changeTranscript.SetLabel("Idioma para buscar a transcri&ção: " + languageName)
			playerDial.Show()
			if isAuto:
				oldWindow.Destroy()
				oldStream.free()
				oldStream.isLoaded=False

			else:
				currentWindow.Hide()

			createFile("data/watcheds.txt")
			watchedsFile=open("data/watcheds.txt", "r")
			for videoPosition in watchedsFile:
				videoPosition=videoPosition.strip()
				videoList=videoPosition.split(":")
				if videoData["id"]==videoList[0]:
					resumeDial=wx.Dialog(playerDial, title="Retomando vídeo")
					cancelResume=wx.Button(resumeDial, label="&Cancelar")
					def onResumeCancel(event):
						self.isRepositioning=False
						resumeDial.Destroy()
						videoStream.set_position(0)
						videoStream.play()
						DmThread(target=checkPlayerState).start()

					cancelResume.Bind(wx.EVT_BUTTON, onResumeCancel)
					def onPassComplete(event):
						resumeDial.Destroy()
						videoStream.play()
						DmThread(target=checkPlayerState).start()

					app.Bind(EVT_PASS, onPassComplete)
					prevPosition=int(videoList[1])
					DmThread(target=passTo, args=(prevPosition,)).start()
					resumeDial.Show()
					break


			else:
				videoStream.play()
				DmThread(target=checkPlayerState).start()

			watchedsFile.close()

		if (isAuto and not self.shouldPlayNext) or not currentWindow:
			videoStream.free()
			return

		currentWindow.Bind(EVT_LOAD, onVideoLoad)
		wx.PostEvent(currentWindow, LoadEvent(currentWindow=currentWindow, videoStream=videoStream, videoData=videoData, videosData=videosData, isPlaylist=isPlaylist, isAuto=isAuto, playlistData=playlistData, playlistItems=playlistItems, oldWindow=oldWindow, oldStream=oldStream, channelData=channelData))

	def addListItems(self, textBox, list):
		for index, item in enumerate(list):
			if index<len(list)-1:
				textBox.AppendText(item+"\n")

			else:
				textBox.AppendText(item)


		textBox.SetInsertionPoint(0)

	def getFeedData(self, entry):
		publishedAtOriginal=entry["published"]
		publishedAt=datetime.strptime(publishedAtOriginal, "%Y-%m-%dT%H:%M:%S+%f:00")
		publishedAt=convertTimezone(publishedAt)
		videoData={
			"videoTitle": entry["title"],
			"channelTitle": entry["author"],
			"id": entry["yt_videoid"],
			"channelId": entry["yt_channelid"],
			"publishedAt": publishedAt,
		}
		return videoData

	def playSound(self, soundName):
		soundPath=os.path.join("sounds", soundName+".wav")
		if self.getSetting("sounds"):
			self.currentSound=stream.FileStream(file=soundPath)
			self.currentSound.play()


	def initUi(self):
		def getSubData(sub):
			subData={
				"channelTitle": sub["snippet"]["title"],
				"id": sub["id"],
				"channelId": sub["snippet"]["resourceId"]["channelId"],
			}
			return subData

		def posToSeconds(string):
			timeParts=string.split(":")
			for index, part in enumerate(timeParts):
				if part.startswith("0"):
					timeParts[index]=part[1:]

			minutes=int(timeParts[0])*60
			seconds=int(timeParts[1])
			totalSeconds=minutes+seconds
			return totalSeconds


		createFile("search_history.txt")
		searchFile=openFile("search_history.txt")
		searchHistory=[search.strip() for search in searchFile]
		searchFile.close()
		searchLabel=wx.StaticText(self, label="&Pesquisar")
		searchBox=wx.ComboBox(self, style=wx.TE_PROCESS_ENTER|wx.TE_DONTWRAP, choices=searchHistory)
		searchBox.SetAccessible(AccessibleSearch())
		def onSearchKeyDown(event):
			keyCode=event.GetKeyCode()
			shiftPressed=wx.GetKeyState(wx.WXK_SHIFT)
			ctrlPressed=wx.GetKeyState(wx.WXK_CONTROL)
			if shiftPressed and ctrlPressed and keyCode==wx.WXK_DELETE:
				answer=wx.MessageBox("Tem certeza de que deseja limpar todo o histórico?", "Apagar todos os itens", wx.YES_NO|wx.ICON_QUESTION, self)
				if answer==wx.YES:
					searchHistory.clear()
					searchBox.Clear()
					searchFile=open("search_history.txt", "w")
					searchFile.close()

			elif shiftPressed and keyCode==wx.WXK_DELETE:
				searchTerm=searchBox.GetValue()
				if searchTerm in searchHistory:
					answer=wx.MessageBox(f"Tem certeza de que deseja apagar {searchTerm} do histórico?", "Apagar item", wx.YES_NO|wx.ICON_QUESTION, self)
					if answer==wx.YES:
						searchFile=open("search_history.txt", "w")
						for index, oldTerm in enumerate(searchHistory):
							if oldTerm==searchTerm:
								searchHistory.remove(oldTerm)
								searchBox.Delete(index)

							else:
								searchFile.write(searchTerm+"\n")


						searchFile.close()


				else:
					speak("Nenhum item do histórico selecionado para excluir", interrupt=True)


			else:
				event.Skip()

		searchBox.Bind(wx.EVT_KEY_DOWN, onSearchKeyDown)
		def onSearch(event):
			speak("Carregando resultados...")
			searchTerm=searchBox.GetValue()
			def search():
				searchFile=openFile("search_history.txt")
				nonlocal searchHistory
				searchHistory=[search.strip() for search in searchFile]
				searchFile.close()
				searchFile=open("search_history.txt", "w")
				searchFile.write(searchTerm+"\n")
				for index, oldTerm in enumerate(searchHistory):
					if not oldTerm==searchTerm:
						searchFile.write(oldTerm+"\n")

					else:
						searchHistory.pop(index)
						searchBox.Delete(index)


				searchFile.close()
				searchHistory.insert(0, searchTerm)
				searchBox.Insert(searchTerm, 0)
				searchResults=yt.search().list(part="id", q=searchTerm, maxResults=50).execute()
				videoIds=[]
				channelIds=[]
				for result in searchResults.get("items", []):
					if result["id"]["kind"]=="youtube#channel":
						channelIds.append(result["id"]["channelId"])
					elif result["id"]["kind"]=="youtube#video":
						videoIds.append(result["id"]["videoId"])


				channelIds=",".join(channelIds)
				videoIds=",".join(videoIds)
				channels=yt.channels().list(part="id,snippet,statistics", id=channelIds).execute()
				videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoIds).execute()
				self.Bind(EVT_LOAD, onResultsLoaded)
				wx.PostEvent(self, LoadEvent(searchResults=searchResults, videos=videos, channels=channels))

			DmThread(target=search).start()
			def onResultsLoaded(event):
				searchResults=event.searchResults
				resultsDial=Dialog(self, title="Resultados da pesquisa por "+searchTerm)
				resultsClose=wx.Button(resultsDial, wx.ID_CANCEL, "Voltar")
				resultsClose.Bind(wx.EVT_BUTTON, onWindowClose)
				videosLabel=wx.StaticText(resultsDial, label="&Vídeos")
				videosList=VideosList(resultsDial, title="&Vídeos")
				videosList.SetFocus()
				def onGoToChannel(event):
					speak("Carregando canal do autor...")
					videoData=videosList.videoData
					channelId=videoData["channelId"]
					DmThread(target=loadChannel, args=(channelId, resultsDial)).start()

				videosList.goToChannel.Bind(wx.EVT_BUTTON, onGoToChannel)
				channelsLabel=wx.StaticText(resultsDial, label="Ca&nais")
				channelsList=List(resultsDial, title="Canais")
				channelsData=[]
				videosData=[]
				for channel in event.channels.get("items", []):
					channelData=getChannelData(channel)
					addChannel(channelsList, channelData)
					channelsData.append(channelData)

				for video in event.videos.get("items", []):
					try:
						videoData=getVideoData(video)

					except Exception as e:
						continue

					videosList.addVideo(videoData)
					videosData.append(videoData)


				def onChannelSelected(event):
					speak("Carregando canal...")
					item=channelsList.GetFocusedItem()
					channelData=channelsData[item]
					channelId=channelData["id"]
					DmThread(target=loadChannel, args=(channelId, resultsDial)).start()

				channelsList.Bind(wx.EVT_LIST_ITEM_ACTIVATED, onChannelSelected)
				resultsLoadMore=wx.Button(resultsDial, label="&Carregar mais")
				if not "nextPageToken" in searchResults:
					resultsLoadMore.Disable()

				def onLoadMore(event):
					speak("Carregando mais...")
					def loadMore():
						nextPageToken=searchResults["nextPageToken"]
						newResults=yt.search().list(part="id", q=searchBox.GetValue(), type="video", maxResults=50, pageToken=nextPageToken).execute()
						videoIds=[]
						channelIds=[]
						for result in newResults.get("items", []):
							if result["id"]["kind"]=="youtube#channel":
								channelIds.append(result["id"]["channelId"])

							elif result["id"]["kind"]=="youtube#video":
								videoIds.append(result["id"]["videoId"])


						channelIds=",".join(channelIds)
						videoIds=",".join(videoIds)
						channels=yt.channels().list(part="id,snippet,statistics", id=channelIds).execute()
						videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoIds).execute()
						resultsDial.Bind(EVT_LOAD, onMoreResultsLoaded)
						wx.PostEvent(resultsDial, LoadEvent(newResults=newResults, channels=channels, videos=videos))

					DmThread(target=loadMore).start()
					def onMoreResultsLoaded(event):
						newResults=event.newResults
						nonlocal searchResults
						searchResults=newResults
						for channel in event.channels.get("items", []):
							channelData=getChannelData(channel)
							addChannel(channelsList, channelData)
							channelsData.append(channelData)

						for video in event.videos.get("items", []):
							try:
								videoData=getVideoData(video)

							except Exception as e:
								continue

							videosList.addVideo(videoData)
							videosData.append(videoData)

						speak("Resultados carregados.")
						if not "nextPageToken" in newResults:
							speak("Fim dos resultados.")
							resultsLoadMore.Disable()



				resultsLoadMore.Bind(wx.EVT_BUTTON, onLoadMore)
				self.playSound("results")
				resultsDial.Show()


		searchBox.Bind(wx.EVT_TEXT_ENTER, onSearch)
		subscriptions=wx.adv.CommandLinkButton(self, mainLabel="&Inscrições", note="Ver os canais em que você se inscreveu")
		def onSubscriptions(event):
			subs=self.allSubs
			subsDial=Dialog(self, title="Inscrições")
			subsClose=wx.Button(subsDial, wx.ID_CANCEL, "Voltar")
			subsClose.Bind(wx.EVT_BUTTON, onWindowClose)
			subsLabel=wx.StaticText(subsDial, label="&Inscrições")
			subsList=List(subsDial, title="Inscrições")
			subsList.SetFocus()
			subsData=[]
			for sub in subs.get("items", []):
				subData=getSubData(sub)
				subsData.append(subData)
				if not window.getSetting("fix_names"):
					subTitle=subData["channelTitle"]

				else:
					subTitle=subData["channelTitle"].title()

				subsList.Append((subTitle,))

			def onSubSelected(event):
				speak("Carregando canal...")
				item=subsList.GetFocusedItem()
				subData=subsData[item]
				DmThread(target=loadChannel, args=(subData["channelId"], subsDial)).start()

			subsList.Bind(wx.EVT_LIST_ITEM_ACTIVATED, onSubSelected)
			updateSubs=wx.Button(subsDial, label="&Atualizar inscrições")
			def onSubsUpdate(event):
				speak("Atualizando...")
				def updateSubs():
					window.getAllSubs()
					window.getMainSubs()
					self.allSubs=window.allSubs
					self.mainSubs=window.mainSubs
					subs=self.allSubs
					wx.PostEvent(subsDial, LoadEvent(subs=subs))

				def onUpdatedSubsLoaded(event):
					nonlocal subs
					subs=event.subs
					subsList.DeleteAllItems()
					subsData.clear()
					for sub in subs.get("items", []):
						subData=getSubData(sub)
						subsData.append(subData)
						if not window.getSetting("fix_names"):
							subTitle=subData["channelTitle"]

						else:
							subTitle=subData["channelTitle"].title()

						subsList.Append((subTitle,))

					speak("Inscrições atualizadas", interrupt=True)
					subsList.SetFocus()

				subsDial.Bind(EVT_LOAD, onUpdatedSubsLoaded)
				DmThread(target=updateSubs).start()

			updateSubs.Bind(wx.EVT_BUTTON, onSubsUpdate)
			subsDial.Show()

		subscriptions.Bind(wx.EVT_BUTTON, onSubscriptions)
		subscriptions.SetAccessible(AccessibleLinkButton())
		notifications=LinkButton(self, mainLabel="&Notificações", note="Ver os vídeos novos de vários canais em que você está inscrito")
		notifications.SetAccessible(AccessibleLinkButton())
		def onNotifications(event):
			if not window.notifsLoaded:
				wx.MessageBox("As notificações ainda estão sendo carregadas. Aguarde alguns segundos e tente novamente.", "Notificações não carregadas", wx.OK|wx.ICON_INFORMATION, self)
				return

			elif not window.notifList:
				wx.MessageBox("Não há novas notificações no momento.", "Nenhuma notificação", wx.OK|wx.ICON_INFORMATION, self)
				return

			videosData=window.notifList
			videosData.sort(reverse=True, key=lambda element: element["publishedAt"])
			notifDialog=Dialog(self, title="Notificações")
			notifClose=wx.Button(notifDialog, wx.ID_CANCEL, "Voltar")
			notifClose.Bind(wx.EVT_BUTTON, onWindowClose)
			notifLabel=wx.StaticText(notifDialog, label="&Notificações")
			videosList=VideosList(notifDialog, title="Notificações", supportShortcuts=False)
			videosList.SetFocus()
			for videoData in videosData:
				addFeedVideo(videosList, videoData)

			def onNotifSelected(event):
				speak("Carregando vídeo...")
				def getVideo():
					item=videosList.GetFocusedItem()
					feedData=videosData[item]
					videoId=feedData["id"]
					videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=videoId).execute()
					video=videos["items"][0]
					videoData=getVideoData(video)
					self.playVideo(notifDialog, videoData)

				Thread(target=getVideo).start()

			videosList.Bind(wx.EVT_LIST_ITEM_ACTIVATED, onNotifSelected)
			def onGoToChannel(event):
				speak("Carregando canal do autor...")
				feedData=videosList.videoData
				channelId=feedData["channelId"]
				DmThread(target=loadChannel, args=(channelId, notifDialog)).start()

			videosList.goToChannel.Bind(wx.EVT_BUTTON, onGoToChannel)
			self.playSound("notifs")
			notifDialog.Show()

		notifications.Bind(wx.EVT_BUTTON, onNotifications)
		explore=LinkButton(self, mainLabel="&Explorar", note="Ver os vídeos em alta ou mais populares do YouTube atualmente")
		def onExplore(event):
			speak("Carregando explorar...")
			def loadExplore():
				trendingVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", chart="mostPopular", regionCode="BR", maxResults=50).execute()
				categories=yt.videoCategories().list(part="id,snippet", regionCode="br", hl="pt_BR").execute()
				self.Bind(EVT_LOAD, onExploreLoaded)
				wx.PostEvent(self, LoadEvent(trendingVideos=trendingVideos, categories=categories))

			DmThread(target=loadExplore).start()
			def onExploreLoaded(event):
				categoriesList=event.categories["items"]
				categoryId=0
				exploreDial=Dialog(self, title="Vídeos em alta")
				backButton=wx.Button(exploreDial, wx.ID_CANCEL, "Voltar")
				backButton.Bind(wx.EVT_BUTTON, onWindowClose)
				trendingLabel=wx.StaticText(exploreDial, label="&Vídeos em alta")
				videosList=VideosList(exploreDial, title="Vídeos em alta")
				videosList.SetFocus()
				trendingVideos=event.trendingVideos
				videosData=[]
				for video in trendingVideos.get("items", []):
					videoData=getVideoData(video)
					videosData.append(videoData)
					videosList.addVideo(videoData)

				def onGoToChannel(event):
					speak("Carregando canal do autor...")
					videoData=videosList.videoData
					channelId=videoData["channelId"]
					DmThread(target=loadChannel, args=(channelId, exploreDial)).start()

				videosList.goToChannel.Bind(wx.EVT_BUTTON, onGoToChannel)
				categoriesItems=event.categories["items"]
				catDic={
					"Todas": "0"
				}
				for category in categoriesItems:
					catTitle=category["snippet"]["title"]
					catId=category["id"]
					catDic[catTitle]=catId

				catList=[catName for catName in catDic]
				categoriesLabel=wx.StaticText(exploreDial, label="Filtrar por &categoria")
				categoriesBox=wx.ComboBox(exploreDial, style=wx.CB_READONLY, choices=catList)
				categoriesBox.Select(0)
				aplyFilter=wx.Button(exploreDial, label="&Aplicar filtro")
				def onAply(event):
					speak("Carregando vídeos...")
					def loadCategory():
						catTitle=categoriesBox.GetValue()
						catId=catDic[catTitle]
						nonlocal categoryId
						categoryId=catId
						trendingVideos=yt.videos().list(part="id,snippet,statistics,contentDetails", chart="mostPopular", regionCode="br", videoCategoryId=catId, maxResults=50).execute()
						exploreDial.Bind(EVT_LOAD, onCatsLoaded)
						wx.PostEvent(exploreDial, LoadEvent(trendingVideos=trendingVideos))

					DmThread(target=loadCategory).start()
					def onCatsLoaded(event):
						speak("Vídeos carregados", interrupt=True)
						videosList.SetFocus()
						trendingVideos=event.trendingVideos
						videosList.clear()
						for video in trendingVideos.get("items", []):
							videoData=getVideoData(video)
							videosData.append(videoData)
							videosList.addVideo(videoData)



				aplyFilter.Bind(wx.EVT_BUTTON, onAply)
				exploreDial.Show()


		explore.Bind(wx.EVT_BUTTON, onExplore)
		self.URLLabel=wx.StaticText(self, label="Assistir vídeo por &URL direta")
		self.URLBox=TextCtrl(self, style=wx.TE_DONTWRAP)
		def onURL(event):
			self.URLBox=event.GetEventObject()
			URL=self.URLBox.GetValue()
			if not UrlIsValid(URL):
				speak("Esta URL de vídeo não é válida.")
				return

			speak("Carregando vídeo...")
			def getVideo():
				idExp="[a-zA-Z0-9-_]{11}"
				id=re.search(idExp, URL).group()
				videos=yt.videos().list(part="id,snippet,statistics,contentDetails", id=id).execute()
				if not videos["items"]:
					wx.MessageBox("Nenhum vídeo com esta URL foi encontrado. Verifique se você não adicionou nenhum número ou letra à URL por acidente e tente novamente.", "Erro ao carregar vídeo", wx.OK|wx.ICON_ERROR, parent=self)
					return

				video=videos["items"][0]
				videoData=getVideoData(video)
				self.playVideo(self, videoData)

			DmThread(target=getVideo).start()

		self.URLBox.Bind(wx.EVT_TEXT_ENTER, onURL)
		self.settingsBtn=wx.Button(self, label="&Configurações")
		self.settingsBtn.SetAccessible(AccessibleLinkButton())
		def onSettings(event):
			settingsDial=Dialog(self, title="Configurações")
			notifBox=wx.CheckBox(settingsDial, label="Ativar &notificações de novos vídeos")
			if self.getSetting("notifications"):
				notifBox.SetValue(True)

			notifMethods={
				"sound": "Sons de notificação",
				"system": "Notificação do sistema",
			}
			notifMethodsLabel=wx.StaticText(settingsDial, label="&Método de notificação")
			notifMethodsBox=wx.ComboBox(settingsDial, choices=list(notifMethods.values()), style=wx.CB_READONLY)
			notifMethod=notifMethods[self.getSettingOrigin("notif_method")]
			notifMethodsBox.SetStringSelection(notifMethod)
			maxChannelsLabel = wx.StaticText(settingsDial, label="Núme&ro máximo de canais a notificar (recomendado 50. Quanto maior, mais lentas as notificações)")
			maxChannelsBox = TextCtrl(settingsDial)
			maxChannelsBox.SetValue(self.getSettingOrigin("max_channels"))
			checkUpdatesBox=wx.CheckBox(settingsDial, label="Ativar checagem a&utomática de atualizações")
			if self.getSetting("check_updates"):
				checkUpdatesBox.SetValue(True)

			shortcutBox=wx.CheckBox(settingsDial, label="Ativar o &atalho para abrir nova instância (ctrl+shift+b) (requer reiniciar o programa)")
			if self.getSetting("instance_shortcut"):
				shortcutBox.SetValue(True)

			notifShortcutBox=wx.CheckBox(settingsDial, label="A&tivar atalho para carregar novo vídeo (ctrl+shift+n) (requer reiniciar o programa)")
			if self.getSetting("notif_shortcut"):
				notifShortcutBox.SetValue(True)

			enableSounds=wx.CheckBox(settingsDial, label="Ativar &sons do programa")
			enableSounds.SetValue(self.getSetting("sounds"))
			transcriptLanguageLabel = wx.StaticText(settingsDial, label="Idioma padrão para as trans&crições de vídeos")
			transcriptLanguageBox = wx.ComboBox(settingsDial, choices=languageList, style=wx.CB_READONLY)
			languageCode = self.getSettingOrigin("default_transcript_language")
			languageName = list(languageDict.keys())[list(languageDict.values()).index(languageCode)]
			transcriptLanguageBox.SetStringSelection(languageName)
			downloadFolderLabel=wx.StaticText(settingsDial, label="&Pasta padrão para download de vídeos")
			downloadFolder=TextCtrl(settingsDial)
			currentFolder=self.getSettingOrigin("download_folder")
			downloadFolder.SetValue(currentFolder)
			defaultFormatLabel=wx.StaticText(settingsDial, label="&Formato padrão para download de vídeos")
			defaultFormatBox=wx.ComboBox(settingsDial, choices=formatList)
			defaultFormatBox.SetValue(self.getSettingOrigin("default_format"))
			defaultSpeedLabel=wx.StaticText(settingsDial, label="Velocidad&e padrão dos vídeos")
			speedStrings=list(videoSpeeds.keys())
			defaultSpeedBox=wx.ComboBox(settingsDial, choices=speedStrings, style=wx.CB_READONLY)
			defaultSpeedBox.SetValue(self.getSettingOrigin("default_speed"))
			autoplayOnPlaylists=wx.CheckBox(settingsDial, label="Reproduzir o próximo vídeo em uma play&list automaticamente quando um vídeo terminar")
			autoplayOnPlaylists.SetValue(self.getSetting("autoplay_on_playlists"))
			deleteAt=wx.CheckBox(settingsDial, label="Mostrar versão encurtada dos &identificadores nos comentários (excluindo arroba e números do final, você ainda pode ver o identificador completo com ctrl+a)")
			deleteAt.SetValue(self.getSetting("delete_at"))
			fixNames=wx.CheckBox(settingsDial, label="Rem&over letras maiúsculas em excesso nos nomes de vídeos e canais para melhorar a soletração em alguns sintetizadores")
			fixNames.SetValue(self.getSetting("fix_names"))
			ok=wx.Button(settingsDial, wx.ID_OK, "Ok")
			def onOk(event):
				self.setSetting("notifications", notifBox.GetValue())
				notifSelection=notifMethodsBox.GetStringSelection()
				notifMethodsKeys=list(notifMethods.keys())
				notifMethodsValues=list(notifMethods.values())
				notifMethod=notifMethodsKeys[notifMethodsValues.index(notifSelection)]
				if winVersion=="10" or winVersion=="11":
					self.setSettingOrigin("notif_method", notifMethod)

				else:
					if notifMethod=="sound":
						self.setSettingOrigin("notif_method", notifMethod)

					else:
						wx.MessageBox("Este método de notificação não é compatível com sistemas anteriores ao Windows 10, como o windows 7 e 8. Para receber notificações de novos vídeos, você deve utilizar o método de som de notificação", "Método de notificação incompatível", wx.OK|wx.ICON_ERROR, settingsDial)
						return


				self.setSettingOrigin("max_channels", maxChannelsBox.GetValue())
				if checkUpdatesBox.GetValue()==True:
					self.setSetting("check_updates", True)
					if not self.isCheckingUpdates:
						self.startUpdateCheck()


				else:
					self.setSetting("check_updates", False)

				self.setSetting("instance_shortcut", shortcutBox.GetValue())
				self.setSetting("notif_shortcut", notifShortcutBox.GetValue())
				self.setSetting("sounds", enableSounds.GetValue())
				self.setSettingOrigin("default_transcript_language", languageDict[transcriptLanguageBox.GetValue()])
				self.setSettingOrigin("download_folder", downloadFolder.GetValue())
				self.setSettingOrigin("default_format", defaultFormatBox.GetValue())
				self.setSettingOrigin("default_speed", defaultSpeedBox.GetValue())
				self.setSetting("autoplay_on_playlists", autoplayOnPlaylists.GetValue())
				self.setSetting("delete_at", deleteAt.GetValue())
				self.setSetting("fix_names", fixNames.GetValue())
				if self.isFirstInstance:
					self.hotkeyChecker.stop()
					self.createHotkey()
					self.hotkeyChecker.start()

				with open("blind_tube.ini", "w") as configFile:
					self.conf.write(configFile)

				onWindowClose(event)

			ok.Bind(wx.EVT_BUTTON, onOk)
			cancel=wx.Button(settingsDial, wx.ID_CANCEL, "Cancelar")
			cancel.Bind(wx.EVT_BUTTON, onWindowClose)
			settingsDial.Show()

		self.settingsBtn.Bind(wx.EVT_BUTTON, onSettings)
		self.updateBtn=wx.Button(self, label="&Atualizar o programa manualmente")
		def onManualUpdate(event):
			self.update()

		self.updateBtn.Bind(wx.EVT_BUTTON, onManualUpdate)
		self.useTipsLabel=wx.StaticText(self, label="&Dicas de uso")
		tipsFile=openFile("dicas_de_uso.txt")
		self.useTipsBox=TextCtrl(self, style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_DONTWRAP, value=tipsFile.read())
		tipsFile.close()
		self.newsLabel=wx.StaticText(self, label="No&vidades")
		newsFile=openFile("novidades.txt")
		self.newsBox=TextCtrl(self, style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_DONTWRAP, value=newsFile.read())
		newsFile.close()
		self.exitButton=wx.Button(self, wx.ID_CANCEL, "&Sair")
		def onExit(event):
			if self.isFirstInstance:
				self.Hide()

			else:
				self.Destroy()


		self.exitButton.Bind(wx.EVT_BUTTON, onExit)
		self.exitAll=wx.Button(self, label="&Fechar todas as instâncias")
		def onExitAll(event):
			wantToExit=wx.MessageBox("Tem certeza de que deseja encerrar todas as instâncias do Blind Tube em execução? Se você estiver com algum vídeo aberto, certifique-se de clicar em não e fechá-lo com a tecla esc, se quiser gravar a posição onde você o pausou.", "Fechar tudo", wx.YES_NO|wx.ICON_QUESTION, self)
			if wantToExit==wx.YES:
				killProgram()


		self.exitAll.Bind(wx.EVT_BUTTON, onExitAll)
		self.Bind(wx.EVT_CLOSE, onExit)

	def Show(self):
		if not os.path.isfile("data/opened.txt"):
			wx.MessageBox("Bem-vindo ao Blind Tube! Para obter dicas gerais e teclas de atalho para o uso do programa, pressione as teclas alt+d ou procure o campo de edição chamado dicas de uso com tab. Para ver as novidades das últimas atualizações, pressione alt+v ou procure o campo de novidades. Estes textos também estão disponíveis na pasta do programa, nos arquivos dicas_de_uso.txt e novidades.txt.", "Dicas de uso", wx.OK|wx.ICON_INFORMATION)
			createFile("data/opened.txt")

		super().Show()


sys.excepthook=excHandler
threading.excepthook=threadExcHandler
yt=login()
logedIn=True
window=MainWindow(None, "Blind Tube")
window.Show()
app.MainLoop()
sys.exit()