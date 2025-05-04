import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_app/screens/login_screen.dart';
import 'package:healthcare_app/screens/main_screen.dart'; // Main screen with bottom nav
import 'package:provider/provider.dart';
import 'package:healthcare_app/providers/app_state.dart';
import 'package:healthcare_app/services/notification_service.dart'; // Import NotificationService

// Import Mock Services (Remove/replace when using real Firebase)
import 'package:healthcare_app/services/mock/mock_auth_service.dart';
import 'package:healthcare_app/services/mock/mock_firestore_service.dart';

// Initialize Services globally or provide them
final NotificationService notificationService = NotificationService();
final MockAuthService mockAuthService = MockAuthService(); // Use Mock Auth
final MockFirestoreService mockFirestoreService = MockFirestoreService(); // Use Mock Firestore

Future<void> main() async {
  print("DEBUG: main() started."); // <<< ADDED DEBUG LOG
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  print("DEBUG: WidgetsFlutterBinding initialized."); // <<< ADDED DEBUG LOG
  
  // Initialize notification service
  await notificationService.init();
  print("DEBUG: NotificationService initialized."); // <<< ADDED DEBUG LOG
  
  // TODO: Initialize Firebase here when using real Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform, // Use generated options
  // );
  
  print("DEBUG: Running MyApp..."); // <<< ADDED DEBUG LOG
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("DEBUG: MyApp build() started."); // <<< ADDED DEBUG LOG
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

    // Use MultiProvider to provide AppState and Mock Services
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
           print("DEBUG: Creating AppState..."); // <<< ADDED DEBUG LOG
           return AppState(mockAuthService, mockFirestoreService);
        }),
        Provider<MockAuthService>.value(value: mockAuthService),
        Provider<MockFirestoreService>.value(value: mockFirestoreService),
        // When using real Firebase, provide FirebaseAuth.instance and FirebaseFirestore.instance here
      ],
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
        // Use StreamBuilder to listen to auth state changes from MockAuthService
        home: StreamBuilder<MockUser?>(
          stream: mockAuthService.authStateChanges,
          initialData: mockAuthService.currentUser, // <<< MODIFIED: Provide initial data
          builder: (context, snapshot) {
            // Enhanced Debug Log
            print("DEBUG: StreamBuilder builder running. ConnectionState: ${snapshot.connectionState}, HasData: ${snapshot.hasData}, Data: ${snapshot.data}"); 

            // If initialData is provided, we don't need to show a loading indicator for the initial state.
            // The builder will run immediately with initialData (null in this case).

            if (snapshot.hasData) { // snapshot.data will be non-null if user is logged in
              print("DEBUG: StreamBuilder showing MainScreen (user logged in). User: ${snapshot.data?.uid}");
              return const MainScreen();
            } else { // snapshot.data will be null if user is logged out (from initialData or stream event)
              print("DEBUG: StreamBuilder showing LoginScreen (user logged out).");
              return const LoginScreen();
            }
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

