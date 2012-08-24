local progressHUD = guiCreateProgressBar(0.8525,0.0983,0.095,0.0433,true)
guiSetAlpha(progressHUD, 0)

function showProgressHUDtwok(boolean)
	local currentprog = guiProgressBarGetProgress(progressHUD)
	guiSetAlpha(progressHUD, 255)
	guiProgressBarSetProgress(progressHUD, 0)
	setTimer(guiProgressBarSetProgress,100 , 1, progressHUD, 5  )
	setTimer(guiProgressBarSetProgress,200 , 1, progressHUD, 10 )
	setTimer(guiProgressBarSetProgress,300 , 1, progressHUD, 15 )
	setTimer(guiProgressBarSetProgress,400 , 1, progressHUD, 20 )
	setTimer(guiProgressBarSetProgress,500 , 1, progressHUD, 25 )
	setTimer(guiProgressBarSetProgress,600 , 1, progressHUD, 30 )
	setTimer(guiProgressBarSetProgress,700 , 1, progressHUD, 35 )
	setTimer(guiProgressBarSetProgress,800 , 1, progressHUD, 40 )
	setTimer(guiProgressBarSetProgress,900 , 1, progressHUD, 45 )
	setTimer(guiProgressBarSetProgress,1000, 1, progressHUD, 50 )
	setTimer(guiProgressBarSetProgress,1100, 1, progressHUD, 55 )
	setTimer(guiProgressBarSetProgress,1200, 1, progressHUD, 60 )
	setTimer(guiProgressBarSetProgress,1300, 1, progressHUD, 65 )
	setTimer(guiProgressBarSetProgress,1400, 1, progressHUD, 70 )
	setTimer(guiProgressBarSetProgress,1500, 1, progressHUD, 75 )
	setTimer(guiProgressBarSetProgress,1600, 1, progressHUD, 80 )
	setTimer(guiProgressBarSetProgress,1700, 1, progressHUD, 85 )
	setTimer(guiProgressBarSetProgress,1800, 1, progressHUD, 90 )
	setTimer(guiProgressBarSetProgress,100 , 1, progressHUD, 95 )
	setTimer(guiProgressBarSetProgress,2000, 1, progressHUD, 100)
	setTimer(guiSetAlpha              ,2200, 1, progressHUD, 0  )
	--setTimer(guiProgressBarSetProgress, 100, 2000,progressHUD,guiProgressBarGetProgress(progressHUD)+0.5)
	--setTimer(guiSetAlpha, 1500, 1,progressHUD,  0)
end

addCommandHandler("derby",
	function(_,ex, two)
		if ex == "phud" then
			if two == "show" then
				showProgressHUD(true)
			end
		end
	end
)
