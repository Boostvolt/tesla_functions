# tesla_functions
FiveM Tesla vehicle functions.
- **/tesla mark**: Marks your vehicle as your Tesla and creates a blip on the map. This vehicle will be used for commands executed while not being in a vehicle as driver.
- **/tesla pilot**: Makes your vehicle drive to your waypoint autonomous. Execute again to cancel.
- **/tesla crash**: Enables/disables crash avoidance.
- **/tesla dance**: Enables/disables Tesla Dance known from the Tesla Model X for your current vehicle.

## Chargeable cars
- [Tesla Model S](https://github.com/boostvolt/tesla_models)
- [Tesla Model 3](https://github.com/boostvolt/tesla_model3)
- [Tesla Model X](https://github.com/boostvolt/tesla_modelx)
- [Tesla Model Y](https://github.com/boostvolt/tesla_modely)
- [Tesla Cybertruck](https://github.com/boostvolt/tesla_cybertruck)
- [Tesla Roadster](https://github.com/boostvolt/tesla_roadster)
- [Tesla Semi](https://github.com/boostvolt/tesla_semi)

## Download

This resource was developed alongside [tesla_ev](https://github.com/boostvolt/tesla_ev), [tesla_supercharger](https://github.com/boostvolt/tesla_supercharger) and [tesla_redis](https://github.com/boostvolt/redis). This resource works without them, but you might be interested in installing them altogether.

### Using Git
```
cd resources
git clone https://github.com/boostvolt/tesla_functions [tesla]/tesla_functions/
```

### Manually
- Download https://github.com/boostvolt/tesla_functions/archive/master.zip
- Create and place in in `[tesla]/tesla_functions` directory

## Installation
- Add this in your `server.cfg`:

```lua
start tesla_functions
```

## License

If you distribute a copy or make a fork of the project, you have to credit this project as source.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see http://www.gnu.org/licenses/.
