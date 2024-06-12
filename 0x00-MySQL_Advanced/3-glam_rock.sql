-- SQL script that lists all bands with Glam rock as their main style, ranked by their longevity
-- Column names should be: band_name and lifespan
-- lifespan is computed using formed and split attributes

SELECT band_name, ((COALESCE(split, 2022) - COALESCE(formed, 2022))) AS lifespan
FROM metal_bands
WHERE style LIKE '%Glam rock%'
ORDER BY lifespan DESC
