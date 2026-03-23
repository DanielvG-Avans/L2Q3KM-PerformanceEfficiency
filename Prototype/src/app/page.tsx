export default function Home() {
  return (
    <main className="min-h-screen bg-linear-to-br from-slate-50 to-slate-200 flex items-center justify-center p-6">
      <div className="w-full max-w-md rounded-2xl bg-white shadow-xl p-8 text-center">
        <h1 className="text-3xl font-bold text-slate-800 mb-2">
          Rendering Demo
        </h1>
        <p className="text-slate-500 mb-8">Choose a page to explore:</p>

        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <a
            href="/ssr"
            className="inline-flex items-center justify-center rounded-xl bg-blue-600 px-6 py-3 text-white font-semibold hover:bg-blue-700 transition-colors">
            SSR
          </a>
          <a
            href="/csr"
            className="inline-flex items-center justify-center rounded-xl bg-emerald-600 px-6 py-3 text-white font-semibold hover:bg-emerald-700 transition-colors">
            CSR
          </a>
        </div>
      </div>
    </main>
  );
}
