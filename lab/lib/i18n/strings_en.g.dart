///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$en app = Translations$app$en._(_root);
	late final Translations$auth$en auth = Translations$auth$en._(_root);
	late final Translations$tabs$en tabs = Translations$tabs$en._(_root);
	late final Translations$home$en home = Translations$home$en._(_root);
	late final Translations$cache$en cache = Translations$cache$en._(_root);
	late final Translations$tasks$en tasks = Translations$tasks$en._(_root);
	late final Translations$validation$en validation = Translations$validation$en._(_root);
	late final Translations$errors$en errors = Translations$errors$en._(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Lemsa Lab'
	String get title => 'Lemsa Lab';
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome'
	String get title => 'Welcome';

	/// en: 'Email'
	String get emailLabel => 'Email';

	/// en: 'Sign in'
	String get signIn => 'Sign in';

	/// en: 'Sign out'
	String get signOut => 'Sign out';

	/// en: 'Enter your email'
	String get emailRequired => 'Enter your email';

	/// en: 'Signed in as $email'
	String signedInAs({required Object email}) => 'Signed in as ${email}';
}

// Path: tabs
class Translations$tabs$en {
	Translations$tabs$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tasks'
	String get tasks => 'Tasks';

	/// en: 'Calendar'
	String get calendar => 'Calendar';

	/// en: 'Stats'
	String get stats => 'Stats';

	/// en: 'Profile'
	String get profile => 'Profile';
}

// Path: home
class Translations$home$en {
	Translations$home$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Calendar — coming soon'
	String get calendarPlaceholder => 'Calendar — coming soon';

	/// en: 'Stats — coming soon'
	String get statsPlaceholder => 'Stats — coming soon';
}

// Path: cache
class Translations$cache$en {
	Translations$cache$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Simulate offline remote'
	String get simulateOffline => 'Simulate offline remote';

	/// en: 'Creates stay local with pending sync badge'
	String get simulateOfflineHint => 'Creates stay local with pending sync badge';

	/// en: 'Flaky remote API (~40% fail)'
	String get flakyApi => 'Flaky remote API (~40% fail)';

	/// en: 'Random network errors while online — test error snackbars'
	String get flakyApiHint => 'Random network errors while online — test error snackbars';

	/// en: 'Fail next API call'
	String get failNext => 'Fail next API call';

	/// en: 'Next create/update/sync hits NetworkFailure once'
	String get failNextHint => 'Next create/update/sync hits NetworkFailure once';

	/// en: 'Sync cache now'
	String get syncNow => 'Sync cache now';

	/// en: 'Syncing…'
	String get syncing => 'Syncing…';

	/// en: 'Sync done — pulled $pulled, flushed $flushed, pending $pending'
	String syncOk({required Object pulled, required Object flushed, required Object pending}) => 'Sync done — pulled ${pulled}, flushed ${flushed}, pending ${pending}';

	/// en: 'Offline — showing cache only'
	String get syncOffline => 'Offline — showing cache only';

	/// en: '$pending pending · pulled $pulled · flushed $flushed'
	String syncStatus({required Object pending, required Object pulled, required Object flushed}) => '${pending} pending · pulled ${pulled} · flushed ${flushed}';
}

// Path: tasks
class Translations$tasks$en {
	Translations$tasks$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tasks'
	String get title => 'Tasks';

	/// en: 'Add task'
	String get addTitle => 'Add task';

	/// en: 'Title'
	String get titleLabel => 'Title';

	/// en: 'Confirm title'
	String get titleConfirmLabel => 'Confirm title';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Saving…'
	String get saving => 'Saving…';

	/// en: 'Task saved'
	String get saved => 'Task saved';

	/// en: 'Task updated'
	String get updated => 'Task updated';

	/// en: 'Marked done'
	String get markDone => 'Marked done';

	/// en: 'Marked pending'
	String get markPending => 'Marked pending';

	/// en: 'No cached tasks — pull to sync from remote'
	String get emptyCache => 'No cached tasks — pull to sync from remote';

	/// en: 'Pending sync'
	String get pendingSync => 'Pending sync';

	/// en: 'Sync failed'
	String get syncFailed => 'Sync failed';
}

// Path: validation
class Translations$validation$en {
	Translations$validation$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Required'
	String get required => 'Required';

	/// en: 'Invalid email'
	String get email => 'Invalid email';

	/// en: 'At least $n characters'
	String minLength({required Object n}) => 'At least ${n} characters';

	/// en: 'Passwords do not match'
	String get passwordMismatch => 'Passwords do not match';

	/// en: 'Check the form'
	String get form => 'Check the form';
}

// Path: errors
class Translations$errors$en {
	Translations$errors$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Network error — try again'
	String get network => 'Network error — try again';

	/// en: 'Invalid $field'
	String validation({required Object field}) => 'Invalid ${field}';

	/// en: 'Not found'
	String get notFound => 'Not found';

	/// en: 'Something went wrong'
	String get unknown => 'Something went wrong';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Lemsa Lab',
			'auth.title' => 'Welcome',
			'auth.emailLabel' => 'Email',
			'auth.signIn' => 'Sign in',
			'auth.signOut' => 'Sign out',
			'auth.emailRequired' => 'Enter your email',
			'auth.signedInAs' => ({required Object email}) => 'Signed in as ${email}',
			'tabs.tasks' => 'Tasks',
			'tabs.calendar' => 'Calendar',
			'tabs.stats' => 'Stats',
			'tabs.profile' => 'Profile',
			'home.calendarPlaceholder' => 'Calendar — coming soon',
			'home.statsPlaceholder' => 'Stats — coming soon',
			'cache.simulateOffline' => 'Simulate offline remote',
			'cache.simulateOfflineHint' => 'Creates stay local with pending sync badge',
			'cache.flakyApi' => 'Flaky remote API (~40% fail)',
			'cache.flakyApiHint' => 'Random network errors while online — test error snackbars',
			'cache.failNext' => 'Fail next API call',
			'cache.failNextHint' => 'Next create/update/sync hits NetworkFailure once',
			'cache.syncNow' => 'Sync cache now',
			'cache.syncing' => 'Syncing…',
			'cache.syncOk' => ({required Object pulled, required Object flushed, required Object pending}) => 'Sync done — pulled ${pulled}, flushed ${flushed}, pending ${pending}',
			'cache.syncOffline' => 'Offline — showing cache only',
			'cache.syncStatus' => ({required Object pending, required Object pulled, required Object flushed}) => '${pending} pending · pulled ${pulled} · flushed ${flushed}',
			'tasks.title' => 'Tasks',
			'tasks.addTitle' => 'Add task',
			'tasks.titleLabel' => 'Title',
			'tasks.titleConfirmLabel' => 'Confirm title',
			'tasks.save' => 'Save',
			'tasks.saving' => 'Saving…',
			'tasks.saved' => 'Task saved',
			'tasks.updated' => 'Task updated',
			'tasks.markDone' => 'Marked done',
			'tasks.markPending' => 'Marked pending',
			'tasks.emptyCache' => 'No cached tasks — pull to sync from remote',
			'tasks.pendingSync' => 'Pending sync',
			'tasks.syncFailed' => 'Sync failed',
			'validation.required' => 'Required',
			'validation.email' => 'Invalid email',
			'validation.minLength' => ({required Object n}) => 'At least ${n} characters',
			'validation.passwordMismatch' => 'Passwords do not match',
			'validation.form' => 'Check the form',
			'errors.network' => 'Network error — try again',
			'errors.validation' => ({required Object field}) => 'Invalid ${field}',
			'errors.notFound' => 'Not found',
			'errors.unknown' => 'Something went wrong',
			_ => null,
		};
	}
}
