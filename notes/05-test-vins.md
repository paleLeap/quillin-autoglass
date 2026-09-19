# Test VINs

All 14 verified end to end on 2026-09-19: valid check digit, decode clean from
vPIC (ErrorCode 0), and resolve to the archetype listed. Serials are 000001, so
these are structurally real but not attached to a specific car.

| VIN | Decodes as | Archetype | Panes | Camera step | Work quoted |
|---|---|---|---|---|---|
| `4T1G11AK8LU000001` | 2020 Toyota Camry | sedan | 9 | skipped | Windshield + ADAS |
| `1HGCV1F33LA000001` | 2020 Honda Accord | sedan | 9 | skipped | Windshield + ADAS |
| `5YJ3E1EA6LF000001` | 2020 Tesla Model 3 | sedan | 9 | skipped | Windshield + ADAS |
| `4T1BF1FK2CU000001` | 2012 Toyota Camry | sedan | 9 | skipped | Windshield only |
| `1FA6P8TH0J5000001` | 2018 Ford Mustang | coupe | 7 | skipped | Windshield only |
| `1FATP8FF0L5000001` | 2020 Ford Mustang | convertible | 4 | skipped | Windshield only |
| `SHHFK7H43JU000001` | 2018 Honda Civic | hatch | 9 | skipped | Windshield only |
| `2HKRW2H89KH000001` | 2019 Honda CR-V | suv | 11 | skipped | Windshield + ADAS |
| `1C4HJXDG9LW000001` | 2020 Jeep Wrangler | suv | 11 | skipped | Windshield only |
| `1FTFW1E84MF000001` | 2021 Ford F-150 | pickup, crew cab | 8 | skipped | Windshield + ADAS |
| `1FTMF1C82MK000001` | 2021 Ford F-150 | pickup, regular cab | 6 | skipped | Windshield + ADAS |
| `3GCUYDED2MG000001` | 2021 Chevrolet Silverado | pickup, crew cab | 8 | **ASKS** | Windshield only |
| `5TDYZ3DC0LS000001` | 2020 Toyota Sienna | van | 10 | skipped | Windshield + ADAS |
| `3AKJHHDR5LS000001` | 2020 Freightliner Cascadia | heavy | 6 | skipped | Windshield only |

## The ones that exercise something specific

- **Silverado** is the only one that reaches the camera question. Its ADAS fields
  come back `Optional` rather than `Standard`, which is exactly the case the step
  exists for. Every other VIN here is settled by the decode and skips it.
- **F-150 crew vs regular cab** is the same model, same year, two different panel
  sets: 8 panes against 6. The regular cab correctly has no rear door glass.
  Note vPIC returns a BLANK door count for both, so the cab string is doing all
  the work.
- **Mustang coupe vs convertible** is the other pair: 7 panes against 4. The
  convertible correctly has no quarter glass and no sunroof.
- **2012 Camry vs 2020 Camry** is the same vehicle eight years apart, and the
  only difference the tool cares about is that the 2020 needs recalibration.
- **Wrangler** decodes as an SUV with no driver assist, which is a useful
  reminder that body style and ADAS are independent.

## Deliberately broken, for testing the failure paths

| Input | Should do |
|---|---|
| `4T1G11AK8LU00000I` | reject: "A VIN never contains the letters I, O or Q" |
| `4T1G11AK9LU000001` | soft warn on the check digit, then decode anyway |
| `4T1G11AK8LU00000` | stay quiet, count down "1 to go" |
| anything unknown | fall through to the year / make / model dropdowns |
