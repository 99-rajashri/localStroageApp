import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  String? _userName;
  String? _userEmail;

  final List<String> _imageAssets = [
    'images/laptopImg1.jpeg',
    'images/laptopImg2.jpg',
    'images/laptopImg3.webp',
    'images/laptopImg4.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _checkUserSession();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return _homeScreen();
      case 1:
        return Center(child: Text('Order Screen'));
      case 2:
        return _profileScreen();
      default:
        return Center(child: Text('Home Screen'));
    }
  }

  Widget _homeScreen() {
    return ListView(
      children: [
        const Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                "Popular Products",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        _buildImageContainer(height: 150, isHorizontal: true),
        const Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                "Featured Products",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        _buildImageContainer(height: 350, isHorizontal: false),
        const Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                "Products Grid",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        _buildImageGrid(),
      ],
    );
  }

  Widget _profileScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage("images/img2.png"),
            backgroundColor: Colors.grey[50],
          ),
          Text(
            'Name: $_userName',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Email: $_userEmail',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(
      {required double height, required bool isHorizontal}) {
    return Container(
      height: height,
      margin: EdgeInsets.all(8.0),
      child: isHorizontal
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageAssets.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  margin: EdgeInsets.only(right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(_imageAssets[index], fit: BoxFit.cover),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: _imageAssets.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 150,
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(_imageAssets[index], fit: BoxFit.cover),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildImageGrid() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _imageAssets.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(_imageAssets[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Future<void> _checkUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/signUp');
    }
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName');
      _userEmail = prefs.getString('userEmail');
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    Navigator.pushReplacementNamed(context, '/signUp');
  }
}
