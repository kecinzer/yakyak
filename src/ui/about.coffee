path      = require 'path'
trifl     = require 'trifl'
ipc       = require('electron').ipcRenderer
remote    = require('electron').remote
clipboard = require('electron').clipboard
Menu      = remote.Menu

#
#
# Catches errors in window and show them in the console
#
window.onerror = (msg, url, lineNo, columnNo, error) ->
    hash = {msg, url, lineNo, columnNo, error}
    ipc.send 'errorInWindow', hash, "About"

aboutlayout = require './views/aboutlayout'

aboutWindow = remote.getCurrentWindow()
# simple context menu that can only copy
aboutWindow.webContents.on 'context-menu', (e, params) ->
    e.preventDefault()
    menuTemplate = [{
        label: 'Copy'
        role: 'copy'
        enabled: params.editFlags.canCopy
    }
    {
        label: "Copy Link"
        visible: params.linkURL != '' and params.mediaType == 'none'
        click: () ->
            if process.platform == 'darwin'
                clipboard
                .writeBookmark params.linkText, params.linkText
            else
                clipboard.writeText params.linkText
    }]
    Menu.buildFromTemplate(menuTemplate).popup aboutWindow

document.body.appendChild aboutlayout.el

link_out = (ev)->
    ev.preventDefault()
    address = e.currentTarget.getAttribute 'href'
    require('electron').shell.openExternal address
    false
