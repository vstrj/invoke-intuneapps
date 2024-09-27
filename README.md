# invoke-intuneapps
Create multiple .intunewin files at once

So far only works as long as there is a single file in the app folder. Might update later with logic to grab any .exe or.msi if several files.

.DESCRIPTION
    The script takes the path to the IntuneWinAppUtil executable, the folder containing the applications, and the output folder as parameters.
    It then processes each application folder, packages the application using IntuneWinAppUtil, and outputs the results to the specified output folder.
