import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_app/screens/login_screen.dart';
import 'package:healthcare_app/screens/main_screen.dart'; // Main screen with bottom nav
import 'package:provider/provider.dart';
import 'package:healthcare_app/providers/app_state.dart';
import 'package:healthcare_app/services/notification_service.dart'; // Import NotificationService

// Initialize NotificationService globally or pass it down
final NotificationService notificationService = NotificationService();

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification service
  await notificationService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the primary color and grey palette based on requirements
    const primaryColor = Color(0xFF2563EB); // blue-600
    const grayPalette = {
      50: Color(0xFFF9FAFB),
      100: Color(0xFFF3F4F6),
      200: Color(0xFFE5E7EB),
      300: Color(0xFFD1D5DB),
      400: Color(0xFF9CA3AF),
      500: Color(0xFF6B7280),
      600: Color(0xFF4B5563),
      700: Color(0xFF374151),
      800: Color(0xFF1F2937),
      900: Color(0xFF111827),
    };

    final textTheme = TextTheme(
      // Screen Titles (e.g., text-lg font-semibold text-gray-800)
      headlineSmall: GoogleFonts.inter(
        fontSize: 20, // text-lg approx
        fontWeight: FontWeight.w600, // font-semibold
        color: grayPalette[800],
      ),
      // List Item Titles (e.g., text-base font-medium text-gray-900)
      titleMedium: GoogleFonts.inter(
        fontSize: 16, // text-base approx
        fontWeight: FontWeight.w500, // font-medium
        color: grayPalette[900],
      ),
      // Body Text (e.g., text-sm text-gray-700)
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, // text-sm approx
        fontWeight: FontWeight.normal,
        color: grayPalette[700],
      ),
      // Labels (e.g., text-xs font-medium text-gray-500)
      labelSmall: GoogleFonts.inter(
        fontSize: 12, // text-xs approx
        fontWeight: FontWeight.w500, // font-medium
        color: grayPalette[500],
      ),
      // Button Text (using primary action style)
      labelLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white, // For primary button
      ),
    );

    return ChangeNotifierProvider(
      create: (context) => AppState(), // Initialize state management
      child: MaterialApp(
        title: 'Healthcare App Prototype',
        theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: Colors.white, // Clean background
          fontFamily: GoogleFonts.inter().fontFamily,
          textTheme: textTheme,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0, // Minimalist
            iconTheme: IconThemeData(color: grayPalette[700]),
            titleTextStyle: textTheme.headlineSmall?.copyWith(color: grayPalette[800]),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: grayPalette[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), // rounded-lg
              borderSide: BorderSide(color: grayPalette[200]!), // border-gray-200
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: grayPalette[200]!), // border-gray-200
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: primaryColor, width: 1.5), // focus:ring-1 focus:ring-blue-500 (approximated)
            ),
            labelStyle: textTheme.bodyMedium?.copyWith(color: grayPalette[500]),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor, // bg-blue-600
              foregroundColor: Colors.white, // text-white
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // rounded-lg
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // px-4 py-2 approx
              textStyle: textTheme.labelLarge,
              elevation: 1, // Subtle shadow
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: primaryColor, // text-blue-600
              textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
             style: OutlinedButton.styleFrom(
              foregroundColor: grayPalette[700], // text-gray-700
              backgroundColor: grayPalette[100], // bg-gray-100
              side: BorderSide(color: grayPalette[300]!), // Subtle border
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // rounded-lg
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // px-4 py-2 approx
              textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: primaryColor,
            unselectedItemColor: grayPalette[500],
            selectedLabelStyle: textTheme.labelSmall?.copyWith(color: primaryColor),
            unselectedLabelStyle: textTheme.labelSmall,
            type: BottomNavigationBarType.fixed,
            elevation: 2, // Add slight elevation for separation
          ),
          dividerTheme: DividerThemeData(
            color: grayPalette[200], // border-gray-200
            thickness: 1,
          ),
          cardTheme: CardTheme(
             elevation: 1, // shadow-sm
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8.0), // rounded-lg
               side: BorderSide(color: grayPalette[200]!), // border-gray-200
             ),
             margin: EdgeInsets.zero, // Control margin externally
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: primaryColor,
            secondary: primaryColor, // Often same as primary or a complementary color
            background: Colors.white,
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onBackground: grayPalette[900]!,
            onSurface: grayPalette[900]!,
            error: Colors.red.shade600, // Standard error color
            onError: Colors.white,
            brightness: Brightness.light,
          ),
        ),
        // Use Consumer to check login state and show appropriate screen
        home: Consumer<AppState>(
          builder: (context, appState, child) {
            // TODO: Replace this simple check with a more robust auth flow if needed
            // For now, assume login happens and navigates to MainScreen
            // A better approach might involve a splash screen or initial route check
            return appState.isLoggedIn ? const MainScreen() : const LoginScreen();
          },
        ),
        routes: {
          // Define routes for navigation
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MainScreen(), // Use MainScreen for home route
          // Add other routes as screens are built
        },
      ),
    );
  }
}

