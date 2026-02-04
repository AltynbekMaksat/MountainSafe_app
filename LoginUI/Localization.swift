import SwiftUI
import Combine

class Localization: ObservableObject {
    static let shared = Localization()
    
    @Published var currentLanguage: String = "en" {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "appLanguage")
            NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
        }
    }
    
    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "appLanguage") {
            currentLanguage = savedLanguage
        } else {
            let systemLanguage = Locale.current.languageCode ?? "en"
            if ["en", "ru", "kk"].contains(systemLanguage) {
                currentLanguage = systemLanguage
            } else {
                currentLanguage = "en"
            }
        }
    }
    
    func localizedString(_ key: String) -> String {
        let strings: [String: [String: String]] = [
            // Общие
            "welcome": ["en": "Welcome!", "ru": "Добро пожаловать!", "kk": "Қош келдіңіз!"],
            "loading": ["en": "Loading...", "ru": "Загрузка...", "kk": "Жүктелуде..."],
            "ok": ["en": "OK", "ru": "OK", "kk": "OK"],
            "cancel": ["en": "Cancel", "ru": "Отмена", "kk": "Бас тарту"],
            "save": ["en": "Save", "ru": "Сохранить", "kk": "Сақтау"],
            "done": ["en": "Done", "ru": "Готово", "kk": "Дайын"],
            "back": ["en": "Back", "ru": "Назад", "kk": "Артқа"],
            "close": ["en": "Close", "ru": "Закрыть", "kk": "Жабу"],
            "yes": ["en": "Yes", "ru": "Да", "kk": "Иә"],
            "no": ["en": "No", "ru": "Нет", "kk": "Жоқ"],
            
            // Авторизация
            "sign_in": ["en": "Sign In", "ru": "Войти", "kk": "Кіру"],
            "sign_up": ["en": "Sign Up", "ru": "Регистрация", "kk": "Тіркелу"],
            "email": ["en": "Email", "ru": "Эл. почта", "kk": "Эл. пошта"],
            "password": ["en": "Password", "ru": "Пароль", "kk": "Құпия сөз"],
            "confirm_password": ["en": "Confirm Password", "ru": "Подтвердите пароль", "kk": "Құпия сөзді растау"],
            "forgot_password": ["en": "Forgot Password?", "ru": "Забыли пароль?", "kk": "Құпия сөзді ұмыттыңыз ба?"],
            "create_account": ["en": "Create Account", "ru": "Создать аккаунт", "kk": "Тіркелгі жасау"],
            "dont_have_account": ["en": "Don't have an account?", "ru": "Нет аккаунта?", "kk": "Тіркелгіңіз жоқ па?"],
            "have_account": ["en": "Already have an account?", "ru": "Уже есть аккаунт?", "kk": "Тіркелгіңіз бар ма?"],
            
            // Табы и навигация
            "home": ["en": "Home", "ru": "Главная", "kk": "Басты бет"],
            "routes": ["en": "Routes", "ru": "Маршруты", "kk": "Маршруттар"],
            "track": ["en": "Track", "ru": "Отслеживание", "kk": "Бақылау"],
            "profile": ["en": "Profile", "ru": "Профиль", "kk": "Профиль"],
            "admin": ["en": "Admin", "ru": "Админ", "kk": "Админ"],
            "navigation": ["en": "Navigation", "ru": "Навигация", "kk": "Навигация"],
            
            // Погода
            "weather": ["en": "Weather", "ru": "Погода", "kk": "Ауа райы"],
            "humidity": ["en": "Humidity", "ru": "Влажность", "kk": "Ылғалдылық"],
            "wind": ["en": "Wind", "ru": "Ветер", "kk": "Жел"],
            "precip": ["en": "Precip", "ru": "Осадки", "kk": "Жауын-шашын"],
            "sunrise": ["en": "Sunrise", "ru": "Восход", "kk": "Күн шығу"],
            "sunset": ["en": "Sunset", "ru": "Закат", "kk": "Күн бату"],
            "weather_unavailable": ["en": "Weather data unavailable", "ru": "Данные о погоде недоступны", "kk": "Ауа райы деректері қолжетімді емес"],
            "details": ["en": "Details", "ru": "Подробности", "kk": "Толығырақ"],
            "temperature": ["en": "Temperature", "ru": "Температура", "kk": "Температура"],
            "condition": ["en": "Condition", "ru": "Состояние", "kk": "Жағдай"],
            "pressure": ["en": "Pressure", "ru": "Давление", "kk": "Қысым"],
            "visibility": ["en": "Visibility", "ru": "Видимость", "kk": "Көру қашықтығы"],
            
            // Маршруты
            "search_routes": ["en": "Search routes...", "ru": "Поиск маршрутов...", "kk": "Маршруттарды іздеу..."],
            "all": ["en": "All", "ru": "Все", "kk": "Барлығы"],
            "easy": ["en": "Easy", "ru": "Легкий", "kk": "Жеңіл"],
            "medium": ["en": "Medium", "ru": "Средний", "kk": "Орташа"],
            "hard": ["en": "Hard", "ru": "Сложный", "kk": "Қиын"],
            "elevation": ["en": "Elevation", "ru": "Высота", "kk": "Биіктік"],
            "distance": ["en": "Distance", "ru": "Дистанция", "kk": "Қашықтық"],
            "time": ["en": "Time", "ru": "Время", "kk": "Уақыт"],
            "calories": ["en": "Calories", "ru": "Калории", "kk": "Калориялар"],
            "view_details": ["en": "View Details", "ru": "Подробнее", "kk": "Толығырақ"],
            "description": ["en": "Description", "ru": "Описание", "kk": "Сипаттама"],
            "best_time": ["en": "Best Time", "ru": "Лучшее время", "kk": "Үздік уақыт"],
            "equipment": ["en": "Equipment", "ru": "Снаряжение", "kk": "Жабдықтар"],
            "tips": ["en": "Tips", "ru": "Советы", "kk": "Кеңестер"],
            "start_tracking": ["en": "Start Tracking", "ru": "Начать отслеживание", "kk": "Бақылауды бастау"],
            "elevation_gain": ["en": "Elevation Gain", "ru": "Набор высоты", "kk": "Биіктік өсімі"],
            "duration": ["en": "Duration", "ru": "Длительность", "kk": "Ұзақтығы"],
            "location": ["en": "Location", "ru": "Местоположение", "kk": "Орналасқан жері"],
            
            // Отслеживание
            "track_hike": ["en": "Track Hike", "ru": "Отслеживать поход", "kk": "Саяхатты бақылау"],
            "select_route": ["en": "Select Route", "ru": "Выбрать маршрут", "kk": "Маршрутты таңдау"],
            "current_speed": ["en": "Current Speed", "ru": "Текущая скорость", "kk": "Ағымдағы жылдамдық"],
            "avg_speed": ["en": "Avg Speed", "ru": "Средняя скорость", "kk": "Орташа жылдамдық"],
            "pause": ["en": "Pause", "ru": "Пауза", "kk": "Кідірту"],
            "finish": ["en": "Finish", "ru": "Завершить", "kk": "Аяқтау"],
            "resume": ["en": "Resume", "ru": "Продолжить", "kk": "Жалғастыру"],
            "hike_completed": ["en": "Hike Completed!", "ru": "Поход завершен!", "kk": "Саяхат аяқталды!"],
            "start_hiking": ["en": "Start Hiking", "ru": "Начать поход", "kk": "Саяхатты бастау"],
            
            // Профиль
            "sign_out": ["en": "Sign Out", "ru": "Выйти", "kk": "Шығу"],
            "hiking_statistics": ["en": "Hiking Statistics", "ru": "Статистика походов", "kk": "Саяхат статистикасы"],
            "hikes": ["en": "Hikes", "ru": "Походы", "kk": "Саяхаттар"],
            "peaks": ["en": "Peaks", "ru": "Вершины", "kk": "Шыңдар"],
            "favorites": ["en": "Favorites", "ru": "Избранное", "kk": "Таңдаулы"],
            "settings": ["en": "Settings", "ru": "Настройки", "kk": "Параметрлер"],
            "language": ["en": "Language", "ru": "Язык", "kk": "Тіл"],
            "favorite_routes": ["en": "Favorite Routes", "ru": "Любимые маршруты", "kk": "Сүйікті маршруттар"],
            "edit_profile": ["en": "Edit Profile", "ru": "Редактировать профиль", "kk": "Профильді өңдеу"],
            "personal_information": ["en": "Personal Information", "ru": "Личная информация", "kk": "Жеке ақпарат"],
            "hiking_experience": ["en": "Hiking Experience", "ru": "Опыт походов", "kk": "Саяхат тәжірибесі"],
            "beginner": ["en": "Beginner", "ru": "Начинающий", "kk": "Бастаушы"],
            "intermediate": ["en": "Intermediate", "ru": "Средний", "kk": "Орташа"],
            "advanced": ["en": "Advanced", "ru": "Продвинутый", "kk": "Кәсіби"],
            "recent_trips": ["en": "Recent Trips", "ru": "Недавние походы", "kk": "Соңғы саяхаттар"],
            "account_settings": ["en": "Account Settings", "ru": "Настройки аккаунта", "kk": "Тіркелгі параметрлері"],
            "change_language": ["en": "Change Language", "ru": "Сменить язык", "kk": "Тілді өзгерту"],
            "see_all": ["en": "See All", "ru": "Смотреть все", "kk": "Барлығын қарау"],
            
            // Быстрые действия
            "quick_actions": ["en": "Quick Actions", "ru": "Быстрые действия", "kk": "Жылдам әрекеттер"],
            "browse_routes": ["en": "Browse Routes", "ru": "Смотреть маршруты", "kk": "Маршруттарды қарау"],
            "start_hike": ["en": "Start Hike", "ru": "Начать поход", "kk": "Саяхатты бастау"],
            "safety_tips": ["en": "Safety Tips", "ru": "Советы безопасности", "kk": "Қауіпсіздік кеңестері"],
            
            // Горы
            "mountain_peaks": ["en": "Mountain Peaks", "ru": "Горные вершины", "kk": "Тау шыңдары"],
            "big_almaty_peak": ["en": "Big Almaty Peak", "ru": "Пик Большой Алматинский", "kk": "Үлкен Алматы шыңы"],
            "kok_zhailau": ["en": "Kok Zhailau", "ru": "Кок Жайляу", "kk": "Көкжайлау"],
            "shymbulak": ["en": "Shymbulak", "ru": "Шымбулак", "kk": "Шымбұлақ"],
            "trans_ili_alatau": ["en": "Trans-Ili Alatau", "ru": "Заилийский Алатау", "kk": "Іле Алатауы"],
            "popular_peak": ["en": "One of the most popular peaks for climbing", "ru": "Одна из самых популярных вершин для восхождения", "kk": "Көтерілу үшін ең танымал шыңдардың бірі"],
            "almaty_pearl": ["en": "Pearl of Almaty", "ru": "Жемчужина Алматы", "kk": "Алматының інжісі"],
            "highest_point": ["en": "Highest point of the Trans-Ili Alatau", "ru": "Высшая точка Заилийского Алатау", "kk": "Іле Алатауының ең биік нүктесі"],
            
            // Трекинг
            "elapsed_time": ["en": "Elapsed Time", "ru": "Прошедшее время", "kk": "Өткен уақыт"],
            "heart_rate": ["en": "Heart Rate", "ru": "Пульс", "kk": "Жүрек соғуы"],
            "speed": ["en": "Speed", "ru": "Скорость", "kk": "Жылдамдық"],
            "progress": ["en": "Progress", "ru": "Прогресс", "kk": "Прогресс"],
            "finish_trip": ["en": "Finish Trip", "ru": "Завершить поход", "kk": "Саяхатты аяқтау"],
            "tracking": ["en": "Tracking", "ru": "Отслеживание", "kk": "Бақылау"],
            "quick_start": ["en": "Quick Start", "ru": "Быстрый старт", "kk": "Жылдам бастау"],
            
            // Языки
            "english": ["en": "English", "ru": "Английский", "kk": "Ағылшын"],
            "russian": ["en": "Russian", "ru": "Русский", "kk": "Орыс"],
            "kazakh": ["en": "Kazakh", "ru": "Казахский", "kk": "Қазақ"],
            
            // Безопасность
            "safety": ["en": "Safety", "ru": "Безопасность", "kk": "Қауіпсіздік"],
            "useful_videos": ["en": "Useful Videos", "ru": "Полезные видео", "kk": "Пайдалы бейнелер"],
            "check_weather": ["en": "Check the weather", "ru": "Проверяйте погоду", "kk": "Ауа райын тексеріңіз"],
            "take_enough_water": ["en": "Take enough water", "ru": "Берите достаточно воды", "kk": "Жеткілікті су алыңыз"],
            "inform_about_route": ["en": "Inform about your route", "ru": "Сообщите о маршруте", "kk": "Маршрут туралы хабарлаңыз"],
            "proper_equipment": ["en": "Proper equipment", "ru": "Правильная экипировка", "kk": "Дұрыс жабдық"],
            "know_your_limits": ["en": "Know your limits", "ru": "Знайте свои пределы", "kk": "Шектеріңізді біліңіз"],
            "emergency_contact": ["en": "Emergency contact", "ru": "Экстренная связь", "kk": "Төтенше байланыс"],
            
            // Админ
            "admin_panel": ["en": "Admin Panel", "ru": "Админ-панель", "kk": "Админ панелі"],
            "user_management": ["en": "User Management", "ru": "Управление пользователями", "kk": "Пайдаланушыларды басқару"],
            "route_management": ["en": "Route Management", "ru": "Управление маршрутами", "kk": "Маршруттарды басқару"],
            "statistics": ["en": "Statistics", "ru": "Статистика", "kk": "Статистика"],
            
            // Дополнительно
            "no_trips_yet": ["en": "No trips yet", "ru": "Пока нет походов", "kk": "Әлі саяхат жоқ"],
            "complete_first_hike": ["en": "Complete your first hike!", "ru": "Завершите свой первый поход!", "kk": "Алғашқы саяхатыңызды аяқтаңыз!"],
            "trip_details": ["en": "Trip Details", "ru": "Детали похода", "kk": "Саяхат туралы мәліметтер"],
            "share_this_trip": ["en": "Share this trip", "ru": "Поделиться походом", "kk": "Бұл саяхатты бөлісу"],
            "start_time": ["en": "Start Time", "ru": "Время начала", "kk": "Басталу уақыты"],
            "end_time": ["en": "End Time", "ru": "Время окончания", "kk": "Аяқталу уақыты"],
            "weather_conditions": ["en": "Weather Conditions", "ru": "Погодные условия", "kk": "Ауа райы жағдайлары"],
            "are_you_sure_sign_out": ["en": "Are you sure you want to sign out?", "ru": "Вы уверены, что хотите выйти?", "kk": "Шығғыңыз келетініне сенімдісіз бе?"],
            "profile_updated": ["en": "Profile updated successfully", "ru": "Профиль успешно обновлен", "kk": "Профиль сәтті жаңартылды"],
            
            // Ошибки и сообщения
            "enter_email": ["en": "Please enter your email address", "ru": "Пожалуйста, введите ваш email", "kk": "Электрондық поштаңызды енгізіңіз"],
            "valid_email": ["en": "Please enter a valid email address", "ru": "Пожалуйста, введите корректный email", "kk": "Дұрыс электрондық пошта енгізіңіз"],
            "enter_password": ["en": "Please enter password", "ru": "Пожалуйста, введите пароль", "kk": "Құпия сөзді енгізіңіз"],
            "password_length": ["en": "Password must be at least 6 characters", "ru": "Пароль должен быть не менее 6 символов", "kk": "Құпия сөз кемінде 6 таңбадан тұруы керек"],
            "passwords_match": ["en": "Passwords don't match", "ru": "Пароли не совпадают", "kk": "Құпия сөздер сәйкес келмейді"],
            "account_created": ["en": "Account created successfully", "ru": "Аккаунт успешно создан", "kk": "Тіркелгі сәтті жасалды"],
            "weak_password": ["en": "Weak", "ru": "Слабый", "kk": "Әлсіз"],
            "medium_password": ["en": "Medium", "ru": "Средний", "kk": "Орташа"],
            "strong_password": ["en": "Strong", "ru": "Сильный", "kk": "Күшті"],
            "password_strength": ["en": "Password strength:", "ru": "Надежность пароля:", "kk": "Құпия сөздің беріктігі:"] ,
        ]
        
        
        if let languageDict = strings[key],
           let localized = languageDict[currentLanguage] {
            return localized
        }
        
        return key
    }
    
    func setLanguage(_ languageCode: String) {
        currentLanguage = languageCode
    }
}
