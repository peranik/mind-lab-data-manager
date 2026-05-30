-- Upit: Analiza alata po laboratorijama
-- Prikazuje za svaku laboratoriju: broj alata, broj razlicitih tipova alata,
-- najstariji i najnoviji datum nabavke, i tip alata koji se najcesce koristi.

SELECT
    l.naziv AS laboratorija,
    COUNT(a.alat_id) AS ukupno_alata,
    COUNT(DISTINCT a.tip_alata_id) AS broj_tipova_alata,
    MIN(a.datum_nabavke) AS prva_nabavka,
    MAX(a.datum_nabavke) AS poslednja_nabavka,
    (
        SELECT ta2.naziv
        FROM alat a2
        JOIN tip_alata ta2 ON a2.tip_alata_id = ta2.tip_alata_id
        WHERE a2.lab_id = l.lab_id
        GROUP BY a2.tip_alata_id, ta2.naziv
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS najcesci_tip_alata
FROM laboratorija l
JOIN alat a ON l.lab_id = a.lab_id
GROUP BY l.lab_id, l.naziv
HAVING COUNT(a.alat_id) > 1
ORDER BY ukupno_alata DESC;