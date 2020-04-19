local alien = "???\n"
local foxen = "Foxen\n"

return {
    intro = {
        alien .. "Hello, I hope somebody is listening... If nobody is listening, am I making any sound at all?",
        foxen .. "What... ?",
        alien .. "Sorry, that was my favorite podcast's intro.",
        alien .. "Anyway, I can't hear anything. I just forgot my stuff on earth.",
        alien .. "If you can hear me, would you be so kind as to send me a signal with that antenna over there?",
        alien .. "First, you'll have to rewire the antenna, then push the big red button on it."
    },
    spacegunFail = {
        foxen .. "Mmh, looks like nothing happened. I should check the wiring again."
    },
    firstAntennaSignal = {
        alien .. "Hey, I just received a signal, that sure means someone's listening to me. Sweet!",
        alien .. "So, listen.",
        alien .. "I'm going to setup the antenna with a target signal.",
        alien .. "If you succeed to send this signal, I should be able to find your galaxy.",
        alien .. "You probably won't have the required modules, but you should be able to build them.",
        alien .. "I left my EM gun next to a small mountain of marvels that you humans like to call 'pile of junk'.",
        alien ..
            "If you wire this gun correctly you should be able to get all the required materials you need to build the modules.",
        alien .. "Good luck!",
        foxen .. "And I will do that because...",
        foxen .. "Erf, that's right, no one can hear me...",
        foxen .. "How convenient."
    },
    secondAntennaSignal = {
        alien .. "I got your galaxy coordinates! Well done, little human. I'm assuming you're human anyway.",
        alien .. "I met a human once. Jack, he was named. Do you know him?",
        alien .. "Actually, you remind me of him. Can I call you Jack?",
        foxen .. "No.",
        alien .. "Alright, Jack. Now I need to locate your planet. I just changed the target signal on the antenna.",
        alien .. "Would you mind rewiring the antenna so you can send me that signal?",
        foxen .. "Sure, it would be my pleasure. I loooove spending my nights beside a pile of junk."
    },
    thirdAntennaSignal = {
        alien .. "Hey Jack, I'm so happy to hear from you again! I have your planet coordinates now.",
        alien .. "It's so great to have a good friend like you.",
        alien .. "We're almost done, the last thing I need is your location on Earth.",
        alien .. "I hope once I'm there we can have a... what's that called?",
        alien .. "That drink that looks like pee and tastes like pee but is not actually pee.",
        alien .. "Anyway, it's what best friends do, I'm told.",
        foxen .. "Oh god, do I have to meet this person?",
        foxen .. "Is it too late to stop helping them?",
    },
    lastAntennaSignal = {
        alien .. "Jack, you're my hero. My best friend and my hero.",
        foxen .. "You must be lonely...",
        alien .. "I have all my coordinates set.",
        alien .. "I'll be there in 3...",
        alien .. "2...",
        alien .. "1..."
    }
}
