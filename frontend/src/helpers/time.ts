export function fixDateShift(
    time: number,
    dateShift: number,
    dateScale: number
): { date: Date; nsRem: number } {
    if (dateShift > 0) {
        const trueValue: number = time;
        let date: Date = new Date(dateShift + trueValue / dateScale);
        let nsRem: number = trueValue * (1_000_000 / dateScale);
        return { date, nsRem: Number((BigInt(nsRem) + BigInt(dateShift) * 1000_000n) % 1000_000_000n) };
    } else {
        return { date: new Date(time), nsRem: (time % 1000) * 1_000_000 };
    }
}

export function displayTimeString(
    time: number,
    dateShift: number,
    dateScale: number,
    cutTimeLenValue: number
): string {
    const { date, nsRem } = fixDateShift(time, dateShift, dateScale);
    return (
        date.getUTCHours().toString().padStart(2, '0') +
        ':' +
        date.getUTCMinutes().toString().padStart(2, '0') +
        ':' +
        date.getUTCSeconds().toString().padStart(2, '0') +
        '.' +
        nsRem.toString().padStart(9, '0')
    ).slice(0, Math.min(cutTimeLenValue, 12));
}

export function displayDateString(
    time: number,
    dateShift: number,
    dateScale: number,
    cutTimeLenValue: number
): string {
    const date = fixDateShift(time, dateShift, dateScale);
    if (dateShift > 0)
        return displayTimeString(time, dateShift, dateScale, cutTimeLenValue);
    return (
        date.date.getUTCDate().toString().padStart(2, '0') +
        '.' +
        (date.date.getUTCMonth() + 1).toString().padStart(2, '0') +
        '.' +
        date.date.getFullYear()
    );
}

export function displayDateTimeString(
    time: number,
    dateShift: number,
    dateScale: number,
    cutTimeLenValue: number
): string {
    const { date, nsRem } = fixDateShift(time, dateShift, dateScale);
    return (
        date.getUTCDate().toString().padStart(2, '0') +
        '.' +
        (date.getUTCMonth() + 1).toString().padStart(2, '0') +
        '.' +
        date.getFullYear() +
        'T' +
        date.getUTCHours().toString().padStart(2, '0') +
        ':' +
        date.getUTCMinutes().toString().padStart(2, '0') +
        ':' +
        date.getUTCSeconds().toString().padStart(2, '0') +
        '.' +
        nsRem.toString().padStart(9, '0')
    ).slice(0, cutTimeLenValue + 11);
}

export function formattedDateAndTime(
    timestamp: number | undefined
): [string, string] {
    if (!timestamp) return ['', ''];
    const dateObj = new Date(timestamp);

    // Format date string
    const year = dateObj.getFullYear();
    const month = dateObj.toLocaleString('default', { month: 'short' });
    const date = dateObj.getDate().toString().padStart(2, '0');
    const formattedDate = `${date} ${month} ${year}`;

    // Format time string
    const hours = dateObj.getUTCHours().toString().padStart(2, '0');
    const minutes = dateObj.getUTCMinutes().toString().padStart(2, '0');
    const seconds = dateObj.getUTCSeconds().toString().padStart(2, '0');
    const formattedTime = `${hours}:${minutes}:${seconds}`;

    return [formattedDate, formattedTime];
}

export const DateTimeString = (
    time: number,
    minResolution: number,
    dateShift: number,
    dateScale: number
) => {
    const cutTimeLen = [18, 17, 16, 15, 14, 13, 12, 11, 10, 8, 8, 5];
    const cutTimeLenValue = cutTimeLen[minResolution];

    const { date, nsRem } = fixDateShift(time, dateShift, dateScale);

    return (
        date.getUTCDate().toString().padStart(2, '0') +
        '.' +
        (date.getUTCMonth() + 1).toString().padStart(2, '0') +
        '.' +
        date.getFullYear() +
        'T' +
        date.getUTCHours().toString().padStart(2, '0') +
        ':' +
        date.getUTCMinutes().toString().padStart(2, '0') +
        ':' +
        date.getUTCSeconds().toString().padStart(2, '0') +
        '.' +
        nsRem.toString().padStart(9, '0')
    ).slice(0, cutTimeLenValue + 11);
};

export const TimeString = (
    time: number,
    minResolution: number,
    dateShift: number,
    dateScale: number
) => {
    const cutTimeLen = [18, 17, 16, 15, 14, 13, 12, 11, 10, 8, 8, 5];
    const cutTimeLenValue = cutTimeLen[minResolution];
    const { date, nsRem } = fixDateShift(time, dateShift, dateScale);

    return (
        date.getUTCHours().toString().padStart(2, '0') +
        ':' +
        date.getUTCMinutes().toString().padStart(2, '0') +
        ':' +
        date.getUTCSeconds().toString().padStart(2, '0') +
        '.' +
        nsRem.toString().padStart(9, '0')
    ).slice(0, Math.min(cutTimeLenValue, 12));
};

export const DateString = (
    time: number,
    minResolution: number,
    dateShift: number,
    dateScale: number
) => {
    const date = fixDateShift(time, dateShift, dateScale);
    if (dateShift > 0)
        return TimeString(time, minResolution, dateShift, dateScale);

    return (
        date.date.getUTCDate().toString().padStart(2, '0') +
        '.' +
        (date.date.getUTCMonth() + 1).toString().padStart(2, '0') +
        '.' +
        date.date.getFullYear()
    );
};
