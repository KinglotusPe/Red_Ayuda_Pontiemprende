package pe.redayuda.location;

import org.springframework.stereotype.Component;

@Component
public class GeoUtils {

    private static final double EARTH_RADIUS_METERS = 6371000.0;

    /**
     * Calcula la distancia en metros entre dos puntos geográficos usando la fórmula de Haversine.
     */
    public double calculateDistanceMeters(double lat1, double lon1, double lat2, double lon2) {
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return EARTH_RADIUS_METERS * c;
    }

    /**
     * Determina el estado de movimiento según desplazamiento y velocidad calculada.
     */
    public String determineMovementState(Double distanceMeters, Long elapsedSeconds) {
        if (distanceMeters == null || distanceMeters < 10.0) {
            return "QUIETO";
        }
        if (elapsedSeconds != null && elapsedSeconds > 0) {
            double speedMetersPerSecond = distanceMeters / elapsedSeconds;
            double speedKmh = speedMetersPerSecond * 3.6;

            if (speedKmh > 25.0) {
                return "MOVIMIENTO_RAPIDO";
            }
        }
        return "DESPLAZAMIENTO";
    }

    /**
     * Comprueba si una nueva ubicación representa una mejora relevante de precisión.
     * Ejemplo: de 850m a 20m.
     */
    public boolean isSignificantAccuracyImprovement(Double oldPrecision, Double newPrecision) {
        if (oldPrecision == null || newPrecision == null) {
            return false;
        }
        // Considera mejora relevante si reduce al menos un 50% el margen de error y es menor a 50m
        return (newPrecision < oldPrecision * 0.5) && (newPrecision < 50.0);
    }

    /**
     * Comprueba si el desplazamiento es relevante para emitir notificación externa (>= 30 metros).
     */
    public boolean isSignificantMovement(double distanceMeters) {
        return distanceMeters >= 30.0;
    }
}
