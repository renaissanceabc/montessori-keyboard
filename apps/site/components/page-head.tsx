/** A page's title and one line on what it covers. */
export function PageHead({ title, line }: { title: string; line: string }) {
  return (
    <header className="page-head">
      <h1>{title}</h1>
      <p>{line}</p>
    </header>
  );
}
