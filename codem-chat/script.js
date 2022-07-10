
    (function() {
        var exist = document.getElementsByClassName('left-curved');
   
        if (exist.length > 0) {
            return
        }
        document.querySelector(".chat-input textarea").placeholder = "/type commands in here";
        
        const leftCurved = document.createElement("img");
        const rightCurved = document.createElement("img");
        const console = document.createElement("img");
        
        leftCurved.setAttribute("src", "https://cdn.discordapp.com/attachments/950484538012864572/953631344473309235/Sol-Alt.png");
        rightCurved.setAttribute("src", "https://cdn.discordapp.com/attachments/950484538012864572/953631344267755520/Sag-Ust.png");
        console.setAttribute("src", "https://cdn.discordapp.com/attachments/862018783391252500/953656287311306752/Console.png");
        
        leftCurved.classList.add("left-curved");
        rightCurved.classList.add("right-curved");
        console.classList.add("console");

        document.querySelector(".chat-input textarea").parentElement.style.position = "relative"
        document.querySelector(".chat-input textarea").parentElement.style.width = "449px"

        document.querySelector(".chat-input textarea").parentElement.appendChild(leftCurved);
        document.querySelector(".chat-input textarea").parentElement.appendChild(rightCurved);
        document.querySelector(".chat-input textarea").parentElement.appendChild(console);


    })();
