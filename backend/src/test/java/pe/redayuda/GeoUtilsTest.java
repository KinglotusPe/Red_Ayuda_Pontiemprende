package pe.redayuda;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import pe.redayuda.location.GeoUtils;

import static org.junit.jupiter.api.Assertions.*;

class GeoUtilsTest {

    private GeoUtils geoUtils;

    @BeforeEach
    void setUp() {
        geoUtils = new GeoUtils();
    }

    @Test
    void testCalculateDistanceAyacuchoPlazaMayorToHospitalRegional() {
        // Plaza Mayor de Huamanga (-13.1631, -74.2236)
        // Hospital Regional de Ayacucho (-13.1706, -74.2155)
        double lat1 = -13.1631;
        double lon1 = -74.2236;
        double lat2 = -13.1706;
        double lon2 = -74.2155;

        double distance = geoUtils.calculateDistanceMeters(lat1, lon1, lat2, lon2);

        // La distancia real en línea recta es aprox. 1.2 km (1200m)
        assertTrue(distance > 1000 && distance < 1500, "Distancia esperada entre 1000m y 1500m, obtenida: " + distance);
    }

    @Test
    void testDetermineMovementStateQuiet() {
        String state = geoUtils.determineMovementState(3.0, 10L);
        assertEquals("QUIETO", state);
    }

    @Test
    void testDetermineMovementStateWalking() {
        // 50 metros en 30 segundos = 1.66 m/s = 6 km/h -> DESPLAZAMIENTO
        String state = geoUtils.determineMovementState(50.0, 30L);
        assertEquals("DESPLAZAMIENTO", state);
    }

    @Test
    void testDetermineMovementStateRapid() {
        // 300 metros en 20 segundos = 15 m/s = 54 km/h -> MOVIMIENTO_RAPIDO
        String state = geoUtils.determineMovementState(300.0, 20L);
        assertEquals("MOVIMIENTO_RAPIDO", state);
    }

    @Test
    void testSignificantAccuracyImprovement() {
        // Precisión pasa de 850m a 20m -> Gran mejora
        assertTrue(geoUtils.isSignificantAccuracyImprovement(850.0, 20.0));

        // Precisión pasa de 25m a 22m -> Variación normal, no es mejora sustancial
        assertFalse(geoUtils.isSignificantAccuracyImprovement(25.0, 22.0));
    }
}
