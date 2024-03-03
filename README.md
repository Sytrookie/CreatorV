# CreatorV

CreatorV is an all-in-one gamemode that provides all the necessary tools for developmental purposes
in FiveM whether you are a programmer, artist or any other sort of developer looking for a quick and easy lightweight world to test resources in!

## Discord / Support / Dev Discussion

[CreatorV Discord](https://discord.gg/5EUR8SJQnv)

## Dependencies

- fxserver artifact 7290+
- onesync
- [ox_lib](https://github.com/overextended/ox_lib)
- [interact](https://github.com/darktrovx/interact)

## Recommended
- [bob74_ipl](https://github.com/TayMcKenzieNZ/bob74_ipl/tree/6a8323ab3336983af616486c6c579cde84b28633)
- [online-interiors](https://github.com/TayMcKenzieNZ/online-interiors)

## Installation

- Clone the repo (I update a lot) and place in a folder titled CreatorV in the resources directory
- Get the resources listed above under Dependencies
- See CreatorV.cfg for how to setup your server.cfg file


- The resource comes with a start-up batch file to skip TxAdmin as it is not needed for this package and in the interest of simplicity, time, usability...
- Grab a server artifact [here for windows](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/) or [here for linux](https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/)
- Extract the server artifact into FXServer folder
- Use the start.bat file to start up the server
- If you need help please see [CFX Server Setup Guide](https://docs.fivem.net/docs/server-manual/setting-up-a-server-vanilla/#windows)
  
## Exports

### Server

#### addCommand

- Registers a command and follows ox_lib command structure, processes the commands into a global radial menu accessible via hotkey.
  
```lua
exports.CreatorV:addCommand(command, category, help, params, func)

exports.CreatorV:addCommand('help', 'Help', 'an example of how to use this export', {}, function(source, args, raw)
    print('help command')
end)
```

## Notes

- Resource is intended to be restartable at any point without any trouble, if this changes will indicate

### Enjoy
