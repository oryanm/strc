require('lib.TEsound')

speakers = {}
speakers.sound = TEsound

function speakers:load()
	self:playMusic()
	self.sound.volume('sfx', 0.5)
end

function speakers:play(audioFile, tags, volume, pitch, func)
	return self.sound.play(speakers.prefixPath(audioFile), tags, volume, pitch, func)
end

function speakers:playLooping(audioFile, tags, n, volume, pitch)
	return self.sound.playLooping(speakers.prefixPath(audioFile), tags, n, volume, pitch)
end

function speakers:playSoundEffect(audioFile, tags, volume, pitch, func)
	return self:play(audioFile, 'sfx', volume, pitch, func)
end

function speakers:jumpSound()
	return self:playSoundEffect('jump.wav')
end

function speakers:deathSound()
	return self:playSoundEffect('death.wav')
end

function speakers:hitSound()
	return self:playSoundEffect('hit.wav')
end

function speakers:playMusic()
	return self:playLooping({ 'music1.wav', 'music2.wav', 'music3.wav' }, 'music')
end

function speakers:silence()
	self.sound.stop('music', false)
	self.sound.stop('sfx', false)
end

function speakers.prefixPath(audioFile)
	if type(audioFile) == 'string' then
		audioFile = AUDIO_RESOURCES_PATH .. audioFile
	elseif type(audioFile) == 'table' then
		for i = 1, #audioFile do
			audioFile[i] = AUDIO_RESOURCES_PATH .. audioFile[i]
		end
	end

	return audioFile
end