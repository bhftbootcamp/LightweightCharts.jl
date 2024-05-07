function tensPower(value: string) {
    let x = BigInt(value);
    if (x < 0n) {
        return 1000;
    }
    let p = 0;
    let r;
    while (true) {
        [x, r] = [x / 10n, x % 10n];
        if (r !== 0n) {
            break;
        }
        p++;
    }
    if (p < 10n) {
        return p;
    } else if (p >= 10n && (10n * x + r) % 3n === 0n) {
        return 11;
    } else {
        return 10;
    }
}

function rescaleAndShiftDates(settings) {
    let min_resolution = Infinity;
    for (let data of settings.charts) {
        for (let entry of data.data) {
            min_resolution = Math.min(min_resolution, tensPower(entry.time));
        }
    }
    let date_shift, date_scale;
    if (min_resolution >= 6) {
        date_shift = 0;
        date_scale = 1;
        settings.charts.forEach((data) => {
            data.data.forEach((entry) => {
                entry.time = Number(BigInt(entry.time) / 1000000n); // Convert to milliseconds
            });
        });
    } else {
        let min_datetime = BigInt(
            Math.min(...settings.charts.map((data) => data.data[0].time))
        );
        let max_datetime = BigInt(
            Math.max(
                ...settings.charts.map(
                    (data) => data.data[data.data.length - 1].time
                )
            )
        );
        date_shift = min_datetime / 1000000n;
        let date_shift_ns = date_shift * 1000000n;
        let date_scale_power = 6 - min_resolution;
        let period_days = Math.ceil(
            Number((max_datetime - min_datetime) / (3600n * 24n * 1000000000n))
        );
        let fallback_date_scale_power = 8 - Math.ceil(Math.log10(period_days));
        let scale_power = Math.min(date_scale_power, fallback_date_scale_power);
        date_scale = 10 ** scale_power;
        let div_by = 10 ** (6 - scale_power);
        settings.charts.forEach((data) => {
            data.data.forEach((entry) => {
                entry.time = Number(
                    (BigInt(entry.time) - date_shift_ns) / BigInt(div_by)
                );
            });
        });
    }
    settings.rescale = true;
    settings.minResolution = Number(min_resolution);
    settings.dateShift = Number(date_shift);
    settings.dateScale = Number(date_scale);
}

export { rescaleAndShiftDates };
