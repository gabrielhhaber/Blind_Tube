import time
class Timer:
	def __init__(self, paused=True):#paused by default
		self.paused=paused
		self.pausedTime=0
		if self.paused==False:
			self.start()
	def start(self):
		self.paused=False
		self.pausedTime=0
		self.initialTime=time.time()
	def restart(self):
		self.paused=False
		self.pausedTime=0
		self.initialTime=time.time()
	@property
	def elapsed(self):
		if self.paused:
			return self.pausedTime
		return self._ms(self.pausedTime+time.time()-self.initialTime)
	def pause(self):
		self.pausedTime=self.elapsed
		self.paused=True
	def resume(self):
		self.initialTime=time.time()
		self.paused=False
	def _ms(self, time):
		return int(round(time*1000))